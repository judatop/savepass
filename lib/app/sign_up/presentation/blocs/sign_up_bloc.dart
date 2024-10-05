import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_event.dart';
import 'package:savepass/app/sign_up/presentation/blocs/sign_up_state.dart';
import 'package:savepass/core/widgets/forms/text_form.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpInitialState()) {
    on<SignUpInitialEvent>(_onSignUpInitial);
    on<NameSignUpChangedEvent>(_onNameSignUpChanged);
    on<OpenSignInEvent>(_onOpenSignIn);
    on<OnSubmitFirstStep>(_onOnSubmitFirstStep);
    on<AlreadyHaveAccountEvent>(_onAlreadyHaveAccountEvent);
    on<OpenPrivacyPolicyEvent>(_onOpenPrivacyPolicyEvent);
  }

  FutureOr<void> _onNameSignUpChanged(
    NameSignUpChangedEvent event,
    Emitter<SignUpState> emit,
  ) {
    final name = TextForm.dirty(event.name);
    emit(ChangeSignUpState(state.model.copyWith(name: name)));
  }

  FutureOr<void> _onSignUpInitial(
    SignUpInitialEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(const SignUpInitialState());
  }

  FutureOr<void> _onOpenSignIn(
    OpenSignInEvent event,
    Emitter<SignUpState> emit,
  ) {}

  FutureOr<void> _onOnSubmitFirstStep(
    OnSubmitFirstStep event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      ChangeSignUpState(
        state.model.copyWith(
          submitAlredyClicked: true,
        ),
      ),
    );

    if (!Formz.validate([state.model.name])) {
      return;
    }

    //TODO: Go to next step
  }

  FutureOr<void> _onAlreadyHaveAccountEvent(
    AlreadyHaveAccountEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenSignInState(state.model));
  }

  FutureOr<void> _onOpenPrivacyPolicyEvent(
    OpenPrivacyPolicyEvent event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpLoadingState(state.model));
    emit(OpenPrivacyPolicyState(state.model));
  }
}
