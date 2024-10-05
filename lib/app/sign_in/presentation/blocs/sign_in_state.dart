import 'package:equatable/equatable.dart';
import 'package:savepass/core/widgets/forms/email_form.dart';

abstract class SignInState extends Equatable {
  final SignInStateModel model;

  const SignInState(this.model);

  @override
  List<Object> get props => [model];
}

class SignInInitialState extends SignInState {
  const SignInInitialState() : super(const SignInStateModel());
}

class SignInStateLoadingState extends SignInState {
  const SignInStateLoadingState(super.model);
}

class ChangeSignInState extends SignInState {
  const ChangeSignInState(super.model);
}

class OpenSignUpState extends SignInState {
  const OpenSignUpState(super.model);
}

class SignInStateModel extends Equatable {
  final EmailForm email;

  const SignInStateModel({
    this.email = const EmailForm.pure(),
  });

  SignInStateModel copyWith({
    EmailForm? email,
  }) {
    return SignInStateModel(
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [email];
}
