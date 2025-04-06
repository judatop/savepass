import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/master_password/domain/repositories/master_password_repository.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_cards_model.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_master_password_model.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_passwords_model.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/global/utils/secret_utils.dart';
import 'package:savepass/core/utils/biometric_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/password_utils.dart';
import 'package:savepass/core/utils/security_utils.dart';
import 'package:uuid/uuid.dart';

class MasterPasswordBloc
    extends Bloc<MasterPasswordEvent, MasterPasswordState> {
  final AuthInitRepository authInitRepository;
  final DeviceInfo deviceInfo;
  final MasterPasswordRepository masterPasswordRepository;
  final PasswordRepository passwordRepository;
  final CardRepository cardRepository;
  final BiometricUtils biometricUtils;
  final FlutterSecureStorage secureStorage;

  MasterPasswordBloc({
    required this.authInitRepository,
    required this.deviceInfo,
    required this.masterPasswordRepository,
    required this.passwordRepository,
    required this.cardRepository,
    required this.biometricUtils,
    required this.secureStorage,
  }) : super(const MasterPasswordInitialState()) {
    on<MasterPasswordInitialEvent>(_onMasterPasswordInitialEvent);
    on<OldPasswordChangedEvent>(_onOldPasswordChangedEvent);
    on<NewPasswordChangedEvent>(_onNewPasswordChangedEvent);
    on<RepeatPasswordChangedEvent>(_onRepeatPasswordChangedEvent);
    on<ToggleOldPasswordEvent>(_onToggleOldPasswordEvent);
    on<ToggleNewPasswordEvent>(_onToggleNewPasswordEvent);
    on<ToggleRepeatPasswordEvent>(_onToggleRepeatPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  FutureOr<void> _onMasterPasswordInitialEvent(
    MasterPasswordInitialEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(const MasterPasswordInitialState());
  }

  FutureOr<void> _onOldPasswordChangedEvent(
    OldPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          oldPassword: PasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onNewPasswordChangedEvent(
    NewPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          newPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onRepeatPasswordChangedEvent(
    RepeatPasswordChangedEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          repeatNewPassword: MasterPasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onSubmitEvent(
    SubmitEvent event,
    Emitter<MasterPasswordState> emit,
  ) async {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
          alreadySubmitted: true,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.oldPassword,
      state.model.newPassword,
      state.model.repeatNewPassword,
    ])) {
      emit(
        ChangeMasterPasswordState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final clearOldPassword = state.model.oldPassword.value;
    final clearNewPassword = state.model.newPassword.value;
    final clearRepeatPassword = state.model.repeatNewPassword.value;

    if (clearNewPassword != clearRepeatPassword) {
      emit(
        PasswordsMismatchState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    if (clearOldPassword == clearNewPassword) {
      emit(
        SamePasswordsMasterPasswordState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final profileBloc = Modular.get<ProfileBloc>();
    final saltResponse = await authInitRepository.getUserSalt();
    late String? salt;
    saltResponse.fold(
      (l) {
        salt = null;
      },
      (r) {
        salt = r.data?['salt'];
      },
    );

    if (salt == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    // Old Password Hash Generation
    final derivedKey =
        await SecurityUtils.deriveMasterKey(clearOldPassword, salt!, 32);
    final oldHashedPassword = SecurityUtils.hashMasterKey(derivedKey);
    final deviceId = await deviceInfo.getDeviceId();

    if (deviceId == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    // Check master password
    final checkResponse = await authInitRepository.checkMasterPassword(
      inputSecret: oldHashedPassword,
      deviceId: deviceId,
      biometricHash: '',
    );

    SavePassResponseModel? checkResponseModel;
    checkResponse.fold(
      (l) {
        checkResponseModel = null;
      },
      (r) {
        checkResponseModel = r;
      },
    );

    if (checkResponseModel == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    if (checkResponseModel?.code != ApiCodes.success) {
      emit(
        InvalidMasterPasswordState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    // New Password Hash Generation
    final name = '${const Uuid().v4()}-${SecretUtils.masterPasswordKey}';
    final newPasswordSalt = SecurityUtils.generateSalt(16);
    final newDerivedKey = await SecurityUtils.deriveMasterKey(
      clearOldPassword,
      newPasswordSalt,
      32,
    );
    final newHashedPassword = SecurityUtils.hashMasterKey(newDerivedKey);

    // New Passwords
    final passwordsResponse = await passwordRepository.getPasswords();
    late final SavePassResponseModel? savePassResponse;
    passwordsResponse.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<PasswordModel> passwords = [];

    final passwordsData = savePassResponse?.data;

    if (passwordsData != null && passwordsData['list'] != null) {
      final passwordsList = passwordsData['list'] as List;

      final decryptedPasswords =
          await PasswordUtils.getPasswords(passwordsList, derivedKey);

      passwords.addAll(decryptedPasswords);
    }

    List<UpdatePasswordsModel> passwordsToUpdate = [];

    for (PasswordModel p in passwords) {
      passwordsToUpdate.add(
        UpdatePasswordsModel(
          id: p.id!,
          password: await SecurityUtils.encryptPassword(
            p.password,
            newDerivedKey,
          ),
        ),
      );
    }

    // New Cards
    final cardsRes = await cardRepository.getCards();
    late final SavePassResponseModel? cardResponseModel;
    cardsRes.fold(
      (l) {
        cardResponseModel = null;
      },
      (r) {
        cardResponseModel = r;
      },
    );

    if (cardResponseModel == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<CardModel> cards = [];

    final cardsData = cardResponseModel?.data;

    if (cardsData != null && cardsData['list'] != null) {
      final cardsList = cardsData['list'] as List;

      final decryptedCards =
          await PasswordUtils.getCards(cardsList, derivedKey);

      cards.addAll(decryptedCards);
    }

    List<UpdateCardsModel> cardsToUpdate = [];

    for (CardModel c in cards) {
      cardsToUpdate.add(
        UpdateCardsModel(
          id: c.id!,
          card: await SecurityUtils.encryptPassword(
            c.card,
            newDerivedKey,
          ),
        ),
      );
    }

    final hasBiometrics = await biometricUtils.hasBiometricsSaved();

    final updateMasterPasswordResponse =
        await masterPasswordRepository.updateMasterPassword(
      model: UpdateMasterPasswordModel(
        oldPassword: oldHashedPassword,
        newPassword: newHashedPassword,
        nameNewPassword: name,
        deviceIdParam: deviceId,
        salt: newPasswordSalt,
        passwordsModel: passwordsToUpdate,
        cardsModel: cardsToUpdate,
      ),
    );

    SavePassResponseModel? updateMasterPasswordResponseModel;
    updateMasterPasswordResponse.fold(
      (l) {
        updateMasterPasswordResponseModel = null;
      },
      (r) {
        updateMasterPasswordResponseModel = r;
      },
    );

    if (updateMasterPasswordResponseModel == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final data = updateMasterPasswordResponseModel?.data;

    if (updateMasterPasswordResponseModel == null || data == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final code = updateMasterPasswordResponseModel?.code;

    if (code == ApiCodes.invalidMasterPassword) {
      emit(
        InvalidMasterPasswordState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    if (code == ApiCodes.newPasswordsNeedsToBeDiferent) {
      emit(
        SamePasswordsMasterPasswordState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    if (code != ApiCodes.success) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    profileBloc.add(SaveDerivedKeyEvent(derivedKey: newDerivedKey));
    profileBloc.add(SaveJwtEvent(jwt: data['jwt']));

    if (hasBiometrics) {
      await secureStorage.write(
        key: Env.derivedKey,
        value: base64Encode(newDerivedKey),
      );
    }

    emit(
      MasterPasswordUpdatedState(
        state.model.copyWith(status: FormzSubmissionStatus.success),
      ),
    );
  }

  FutureOr<void> _onToggleOldPasswordEvent(
    ToggleOldPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(showOldPassword: !state.model.showOldPassword),
      ),
    );
  }

  FutureOr<void> _onToggleNewPasswordEvent(
    ToggleNewPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(showNewPassword: !state.model.showNewPassword),
      ),
    );
  }

  FutureOr<void> _onToggleRepeatPasswordEvent(
    ToggleRepeatPasswordEvent event,
    Emitter<MasterPasswordState> emit,
  ) {
    emit(
      ChangeMasterPasswordState(
        state.model.copyWith(
          showRepeatNewPassword: !state.model.showRepeatNewPassword,
        ),
      ),
    );
  }
}
