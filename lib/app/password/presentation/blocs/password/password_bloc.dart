import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password/password_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/password_utils.dart';
import 'package:savepass/core/utils/security_utils.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final Logger log;
  final PreferencesRepository preferencesRepository;
  final PasswordRepository passwordRepository;

  PasswordBloc({
    required this.log,
    required this.preferencesRepository,
    required this.passwordRepository,
  }) : super(const PasswordInitialState()) {
    on<PasswordInitialEvent>(_onPasswordInitialEvent);
    on<ChangeNameEvent>(_onChangeNameEvent);
    on<ChageEmailEvent>(_onChageEmailEvent);
    on<ChangePasswordEvent>(_onChangePasswordEvent);
    on<ChangeTagEvent>(_onChangeTagEvent);
    on<ChangeDescEvent>(_onChangeDescEvent);
    on<TogglePasswordEvent>(_onTogglePasswordEvent);
    on<OnChangeTypeEvent>(_onOnChangeTypeEvent);
    on<OnClickGeneratePasswordEvent>(_onOnClickGeneratePasswordEvent);
    on<SelectNamePasswordEvent>(_onSelectNamePasswordEvent);
    on<SubmitPasswordEvent>(_onSavePasswordEvent);
    on<CopyUserToClipboardEvent>(_onCopyUserToClipboardEvent);
    on<CopyPassToClipboardEvent>(_onCopyPassToClipboardEvent);
    on<DeletePasswordEvent>(_onDeletePasswordEvent);
  }

  FutureOr<void> _onPasswordInitialEvent(
    PasswordInitialEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(
      const ChangePasswordState(
        PasswordStateModel(),
      ),
    );

    final isUpdating = event.selectedPassId != null;

    if (isUpdating) {
      emit(
        ChangePasswordState(
          state.model.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      final profileBloc = Modular.get<ProfileBloc>();
      final derivedKey = profileBloc.state.model.derivedKey;

      if (derivedKey == null) {
        emit(
          ChangePasswordState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
        return;
      }

      final response = await passwordRepository.getPasswordById(
        passwordId: event.selectedPassId!,
      );

      late PasswordModel? passModel;
      response.fold(
        (l) {
          passModel = null;
        },
        (r) {
          if (r.data != null) {
            passModel = PasswordModel.fromJson(r.data!);
          }
        },
      );

      if (passModel == null || passModel?.password == null) {
        emit(
          ErrorLoadingPasswordState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }

      final passwordDecrypted = SecurityUtils.decryptPassword(
                passModel!.password,
                derivedKey,
              );

      emit(
        ChangePasswordState(
          state.model.copyWith(
            status: FormzSubmissionStatus.success,
            passwordSelected: passModel,
            name: TextForm.dirty(passModel!.name ?? ''),
            email: TextForm.dirty(passwordDecrypted.split('|')[0]),
            password: PasswordForm.dirty(
              passwordDecrypted.split('|')[1],
            ),
            singleTag: TextForm.dirty(passModel!.domain ?? ''),
            desc: TextForm.dirty(passModel!.description ?? ''),
            imgUrl: passModel!.typeImg,
            isUpdating: isUpdating,
          ),
        ),
      );
    }

    final response = await preferencesRepository.getPassImages();

    response.fold(
      (l) {},
      (r) {
        emit(
          ChangePasswordState(
            state.model.copyWith(
              images: r,
              imgUrl: isUpdating ? null : r[0].type,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onChangeNameEvent(
    ChangeNameEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          name: TextForm.dirty(event.name),
        ),
      ),
    );
  }

  FutureOr<void> _onChageEmailEvent(
    ChageEmailEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          email: TextForm.dirty(event.email),
        ),
      ),
    );
  }

  FutureOr<void> _onChangePasswordEvent(
    ChangePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          password: PasswordForm.dirty(event.password),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeTagEvent(
    ChangeTagEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          singleTag: TextForm.dirty(event.tag),
        ),
      ),
    );
  }

  FutureOr<void> _onChangeDescEvent(
    ChangeDescEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          desc: TextForm.dirty(event.desc),
        ),
      ),
    );
  }

  FutureOr<void> _onTogglePasswordEvent(
    TogglePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          showPassword: !state.model.showPassword,
        ),
      ),
    );
  }

  FutureOr<void> _onOnChangeTypeEvent(
    OnChangeTypeEvent event,
    Emitter<PasswordState> emit,
  ) {
    final newIndex = event.newIndex;
    final images = state.model.images;

    emit(
      ChangePasswordState(
        state.model.copyWith(
          images: images.map((e) => e.copyWith(selected: false)).toList()
            ..[newIndex] = images[newIndex].copyWith(selected: true),
        ),
      ),
    );
  }

  FutureOr<void> _onOnClickGeneratePasswordEvent(
    OnClickGeneratePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    final generatedPassword = PasswordUtils.generateRandomPassword();
    emit(
      GeneratedPasswordState(
        state.model.copyWith(
          password: PasswordForm.dirty(generatedPassword),
        ),
      ),
    );
  }

  FutureOr<void> _onSelectNamePasswordEvent(
    SelectNamePasswordEvent event,
    Emitter<PasswordState> emit,
  ) {
    String name = event.name;
    final types = state.model.images;

    PassImageModel? passImgModel;

    for (var i = 0; i < types.length; i++) {
      if (types[i].key == name) {
        passImgModel = types[i];
        break;
      }
    }

    if (passImgModel != null) {
      final images = types.map((e) => e.copyWith(selected: false)).toList()
        ..[types.indexOf(passImgModel)] = passImgModel.copyWith(selected: true);

      emit(
        ChangePasswordState(
          state.model.copyWith(
            name: TextForm.dirty(name),
            images: images,
            singleTag: TextForm.dirty(passImgModel.domain ?? ''),
            imgUrl: passImgModel.type,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSavePasswordEvent(
    SubmitPasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.email,
      state.model.password,
    ])) {
      emit(
        ChangePasswordState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final isUpdating = state.model.isUpdating;

    final profileBloc = Modular.get<ProfileBloc>();
    final derivedKey = profileBloc.state.model.derivedKey;

    if (derivedKey == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(
            status: FormzSubmissionStatus.failure,
          ),
        ),
      );
      return;
    }

    final password = '${state.model.email.value}|${state.model.password.value}';

    late final Either<Fail, SavePassResponseModel> response;

    PasswordModel? passwordSelected = state.model.passwordSelected;
    if (isUpdating && passwordSelected != null) {
      response = await passwordRepository.editPassword(
        model: PasswordModel(
          id: passwordSelected.id,
          typeImg: state.model.imgUrl,
          name: state.model.name.value,
          password: await SecurityUtils.encryptPassword(
            password,
            derivedKey,
          ),
          description: state.model.desc.value,
          domain: state.model.singleTag.value,
          vaultId: passwordSelected.vaultId,
        ),
      );
    } else {
      response = await passwordRepository.insertPassword(
        model: PasswordModel(
          typeImg: state.model.imgUrl,
          name: state.model.name.value,
          password: await SecurityUtils.encryptPassword(
            password,
            derivedKey,
          ),
          description: state.model.desc.value,
          domain: state.model.singleTag.value,
        ),
      );
    }

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
      },
      (r) {
        if (r.code == ApiCodes.reachedPasswordsLimit) {
          emit(
            ReachedPasswordsState(
              state.model.copyWith(
                status: FormzSubmissionStatus.failure,
              ),
            ),
          );
          return;
        }

        if (r.code != ApiCodes.success) {
          emit(
            GeneralErrorState(
              state.model.copyWith(
                status: FormzSubmissionStatus.failure,
              ),
            ),
          );
          return;
        }

        emit(
          PasswordCreatedState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onCopyUserToClipboardEvent(
    CopyUserToClipboardEvent event,
    Emitter<PasswordState> emit,
  ) async {
    final user = state.model.email.value;

    await Clipboard.setData(ClipboardData(text: user));

    emit(
      UserCopiedState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onCopyPassToClipboardEvent(
    CopyPassToClipboardEvent event,
    Emitter<PasswordState> emit,
  ) async {
    final password = state.model.password.value;

    await Clipboard.setData(ClipboardData(text: password));

    emit(
      PassCopiedState(
        state.model.copyWith(
          status: FormzSubmissionStatus.success,
        ),
      ),
    );
  }

  FutureOr<void> _onDeletePasswordEvent(
    DeletePasswordEvent event,
    Emitter<PasswordState> emit,
  ) async {
    if (state.model.isUpdating) {
      emit(
        ChangePasswordState(
          state.model.copyWith(
            status: FormzSubmissionStatus.inProgress,
          ),
        ),
      );

      if (state.model.passwordSelected == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }

      final passwordId = state.model.passwordSelected!.id;
      final vaultId = state.model.passwordSelected!.vaultId;

      if (passwordId == null || vaultId == null) {
        emit(
          GeneralErrorState(
            state.model.copyWith(
              status: FormzSubmissionStatus.failure,
            ),
          ),
        );
        return;
      }

      final response = await passwordRepository.deletePassword(
        passwordId: passwordId,
        vaultId: vaultId,
      );

      response.fold(
        (l) {
          emit(
            GeneralErrorState(
              state.model.copyWith(
                status: FormzSubmissionStatus.failure,
              ),
            ),
          );
        },
        (r) {
          if (r.code != ApiCodes.success) {
            emit(
              GeneralErrorState(
                state.model.copyWith(
                  status: FormzSubmissionStatus.failure,
                ),
              ),
            );
            return;
          }

          emit(
            PasswordDeletedState(
              state.model.copyWith(
                status: FormzSubmissionStatus.success,
              ),
            ),
          );
        },
      );
    }
  }
}
