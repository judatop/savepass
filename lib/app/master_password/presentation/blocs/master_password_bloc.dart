import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/master_password/domain/repositories/master_password_repository.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_master_password_model.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_event.dart';
import 'package:savepass/app/master_password/presentation/blocs/master_password_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_event.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/global/utils/secret_utils.dart';
import 'package:savepass/core/utils/device_info.dart';
import 'package:savepass/core/utils/security_utils.dart';
import 'package:uuid/uuid.dart';

class MasterPasswordBloc
    extends Bloc<MasterPasswordEvent, MasterPasswordState> {
  final AuthInitRepository authInitRepository;
  final DeviceInfo deviceInfo;
  final MasterPasswordRepository masterPasswordRepository;

  MasterPasswordBloc({
    required this.authInitRepository,
    required this.deviceInfo,
    required this.masterPasswordRepository,
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
    //TODO: Complete
    // emit(
    //   ChangeMasterPasswordState(
    //     state.model.copyWith(
    //       status: FormzSubmissionStatus.inProgress,
    //       alreadySubmitted: true,
    //     ),
    //   ),
    // );

    // if (!Formz.validate([
    //   state.model.oldPassword,
    //   state.model.newPassword,
    //   state.model.repeatNewPassword,
    // ])) {
    //   emit(
    //     ChangeMasterPasswordState(
    //       state.model.copyWith(status: FormzSubmissionStatus.initial),
    //     ),
    //   );
    //   return;
    // }

    // final clearOldPassword = state.model.oldPassword.value;
    // final clearNewPassword = state.model.newPassword.value;
    // final clearRepeatPassword = state.model.repeatNewPassword.value;

    // if (clearNewPassword != clearRepeatPassword) {
    //   emit(
    //     PasswordsMismatchState(
    //       state.model.copyWith(
    //         status: FormzSubmissionStatus.failure,
    //       ),
    //     ),
    //   );
    //   return;
    // }

    // final saltResponse = await authInitRepository.getUserSalt();
    // late String? salt;
    // saltResponse.fold(
    //   (l) {
    //     salt = null;
    //   },
    //   (r) {
    //     salt = r.data?['salt'];
    //   },
    // );

    // if (salt == null) {
    //   emit(
    //     GeneralErrorState(
    //       state.model.copyWith(status: FormzSubmissionStatus.failure),
    //     ),
    //   );
    //   return;
    // }

    // // Old Password Hash Generation
    // final derivedKey =
    //     await SecurityUtils.deriveMasterKey(clearOldPassword, salt!, 32);
    // final oldHashedPassword = SecurityUtils.hashMasterKey(derivedKey);
    // final deviceId = await deviceInfo.getDeviceId();

    // if (deviceId == null) {
    //   emit(
    //     GeneralErrorState(
    //       state.model.copyWith(status: FormzSubmissionStatus.failure),
    //     ),
    //   );
    //   return;
    // }

    // // New Password Hash Generation
    // final name = '${const Uuid().v4()}-${SecretUtils.masterPasswordKey}';
    // final newPasswordSalt = SecurityUtils.generateSalt(16);
    // final derivedKeyNewPassword = await SecurityUtils.deriveMasterKey(
    //   clearOldPassword,
    //   newPasswordSalt,
    //   32,
    // );
    // final newHashedPassword =
    //     SecurityUtils.hashMasterKey(derivedKeyNewPassword);

    // final updateProfileResponse =
    //     await masterPasswordRepository.updateMasterPassword(
    //   model: UpdateMasterPasswordModel(
    //     oldPassword: oldHashedPassword,
    //     newPassword: newHashedPassword,
    //     nameNewPassword: name,
    //     deviceIdParam: deviceId,
    //     salt: newPasswordSalt,
    //   ),
    // );

    // updateProfileResponse.fold(
    //   (l) {
    //     emit(
    //       GeneralErrorState(
    //         state.model.copyWith(status: FormzSubmissionStatus.failure),
    //       ),
    //     );
    //   },
    //   (r) {
    //     if (r.data == null) {
    //       emit(
    //         GeneralErrorState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //       return;
    //     }

    //     if (r.code == ApiCodes.invalidMasterPassword) {
    //       emit(
    //         InvalidMasterPasswordState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //       return;
    //     }

    //      if (r.code == ApiCodes.newPasswordsNeedsToBeDiferent) {
    //       emit(
    //         SamePasswordsMasterPasswordState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //       return;
    //     }

    //     if (r.code != ApiCodes.success) {
    //       emit(
    //         GeneralErrorState(
    //           state.model.copyWith(status: FormzSubmissionStatus.failure),
    //         ),
    //       );
    //       return;
    //     }

    //     final profileBloc = Modular.get<ProfileBloc>();
    //     profileBloc.add(SaveDerivedKeyEvent(derivedKey: derivedKeyNewPassword));
    //     profileBloc.add(SaveJwtEvent(jwt: r.data!['jwt']));

    //     emit(
    //       MasterPasswordUpdatedState(
    //         state.model.copyWith(status: FormzSubmissionStatus.success),
    //       ),
    //     );
    //   },
    // );
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
            showRepeatNewPassword: !state.model.showRepeatNewPassword),
      ),
    );
  }
}
