import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_event.dart';
import 'package:savepass/app/auth_init/presentation/blocs/auth_init_state.dart';
import 'package:savepass/core/form/password_form.dart';

class AuthInitBloc extends Bloc<AuthInitEvent, AuthInitState> {
  AuthInitBloc() : super(const AuthInitInitialState()) {
    on<AuthInitInitialEvent>(_onAuthInitInitial);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<ToggleMasterPasswordEvent>(_onToggleMasterPasswordEvent);
    on<SubmitEvent>(_onSubmitEvent);
  }

  FutureOr<void> _onAuthInitInitial(
    AuthInitInitialEvent event,
    Emitter<AuthInitState> emit,
  ) {
    emit(const AuthInitInitialState());
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

    try {
      // final user = FirebaseAuth.instance.currentUser;

      // if (user?.email == null) {
      //   throw Exception('User not found');
      // }

      //TODO: uncomment
      // await FirebaseAuth.instance.signInWithCredential(
      //   EmailAuthProvider.credential(
      //     email: user!.email!,
      //     password: state.model.password.value,
      //   ),
      // );

      await Future.delayed(const Duration(seconds: 5));

      emit(
        OpenHomeState(
          state.model.copyWith(status: FormzSubmissionStatus.success),
        ),
      );
    } catch (e) {
      // if (e is FirebaseAuthException) {
      //   if (e.code == 'invalid-credential') {
      //     emit(
      //       InvalidMasterPasswordState(
      //         state.model.copyWith(status: FormzSubmissionStatus.failure),
      //       ),
      //     );
      //   }
      // }

      Logger().e('submit auth error: ${e.toString()}');
    }
  }
}
