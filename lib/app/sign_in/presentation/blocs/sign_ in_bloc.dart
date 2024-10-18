import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_event.dart';
import 'package:savepass/app/sign_in/presentation/blocs/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInInitialState()) {
    on<SignInInitialEvent>(_onSignInInitial);
    on<OpenSignUpEvent>(_onOpenSignUp);
  }

  FutureOr<void> _onSignInInitial(
    SignInInitialEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(const SignInInitialState());
  }

  FutureOr<void> _onOpenSignUp(
    OpenSignUpEvent event,
    Emitter<SignInState> emit,
  ) {
    emit(OpenSignUpState(state.model));
  }
}
