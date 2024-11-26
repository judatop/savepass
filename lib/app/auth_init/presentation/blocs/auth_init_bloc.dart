import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/auth_init/domain/repositories/auth_init_repository.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/core/form/password_form.dart';

class AuthInitBloc extends Bloc<AuthInitEvent, AuthInitState> {
  final ProfileRepository profileRepository;
  final AuthInitRepository authInitRepository;

  AuthInitBloc({
    required this.profileRepository,
    required this.authInitRepository,
  }) : super(const AuthInitInitialState()) {
    on<AuthInitInitialEvent>(_onAuthInitInitial);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  FutureOr<void> _onAuthInitInitial(
    AuthInitInitialEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    emit(const AuthInitInitialState());

    final res = await profileRepository.getProfile();
    res.fold(
      (l) {},
      (r) {
        emit(
          ChangeAuthInitState(
            state.model.copyWith(
              profile: r,
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onPasswordChanged(
    PasswordChangedEvent event,
    Emitter<AuthInitState> emit,
  ) {
    final password = PasswordForm.dirty(event.password);
    emit(ChangeAuthInitState(state.model.copyWith(password: password)));
  }

  FutureOr<void> _onToggleMasterPasswordEvent(
    ToggleMasterPasswordEvent event,
    Emitter<AuthInitState> emit,
  ) {
    emit(
      ChangeAuthInitState(
        state.model.copyWith(showPassword: !state.model.showPassword),
      ),
    );
  }

  FutureOr<void> _onSubmitEvent(
    SubmitEvent event,
    Emitter<AuthInitState> emit,
  ) async {
    emit(
      ChangeAuthInitState(
        state.model.copyWith(
          alreadySubmitted: true,
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    if (!Formz.validate([
      state.model.password,
    ])) {
      emit(
        ChangeAuthInitState(
          state.model.copyWith(status: FormzSubmissionStatus.initial),
        ),
      );
      return;
    }

    final masterPassword = state.model.password.value;

    final response = await authInitRepository.checkMasterPassword(
      inputPassword: masterPassword,
    );

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        if (r) {
          emit(
            OpenHomeState(
              state.model.copyWith(status: FormzSubmissionStatus.success),
            ),
          );
        } else {
          emit(
            InvalidMasterPasswordState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
        }
      },
    );
  }
}
