import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/password/domain/repositories/password_repository.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/password/presentation/blocs/password_event.dart';
import 'package:savepass/app/password/presentation/blocs/password_state.dart';
import 'package:savepass/app/preferences/domain/repositories/preferences_repository.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/form/text_form.dart';
import 'package:savepass/core/utils/password_utils.dart';

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
    on<ToggleAutoTypeEvent>(_onToggleAutoTypeEvent);
    on<OnChangeTypeEvent>(_onOnChangeTypeEvent);
    on<OnClickGeneratePasswordEvent>(_onOnClickGeneratePasswordEvent);
    on<SelectNamePasswordEvent>(_onSelectNamePasswordEvent);
    on<SubmitPasswordEvent>(_onSavePasswordEvent);
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

    final response = await preferencesRepository.getPassImages();

    response.fold(
      (l) {},
      (r) {
        emit(
          ChangePasswordState(
            state.model.copyWith(images: r, imgUrl: r[0].type),
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

  FutureOr<void> _onToggleAutoTypeEvent(
    ToggleAutoTypeEvent event,
    Emitter<PasswordState> emit,
  ) {
    emit(
      ChangePasswordState(
        state.model.copyWith(
          typeAuto: !state.model.typeAuto,
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
    if (state.model.typeAuto) {
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
          ..[types.indexOf(passImgModel)] =
              passImgModel.copyWith(selected: true);

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

    final response = await passwordRepository.insertPassword(
      PasswordModel(
        typeImg: state.model.imgUrl,
        name: state.model.name.value,
        username: state.model.email.value,
        password: state.model.password.value,
        description: state.model.desc.value,
        domain: state.model.singleTag.value,
      ),
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
}
