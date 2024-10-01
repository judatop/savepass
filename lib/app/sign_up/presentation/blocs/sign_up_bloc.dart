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
  ) {}

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

    if (state.model.name.value.length < 3) {
      emit(
        ChangeSignUpState(
          state.model.copyWith(
            name: const TextForm.dirty('Name must have at least 3 characters'),
          ),
        ),
      );
      return;
    }

    emit(
      ChangeSignUpState(
        state.model.copyWith(name: state.model.name),
      ),
    );
  }
}
