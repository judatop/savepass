import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/infrastructure/models/sign_up_password_form.dart';
import 'package:savepass/app/sign_up/infrastructure/models/sign_up_type_enum.dart';
import 'package:savepass/core/form/email_form.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class SignUpState extends Equatable {
  final SignUpStateModel model;

  const SignUpState(this.model);

  @override
  List<Object> get props => [model];
}

class SignUpInitialState extends SignUpState {
  const SignUpInitialState() : super(const SignUpStateModel());
}

class SignUpLoadingState extends SignUpState {
  const SignUpLoadingState(super.model);
}

class ChangeSignUpState extends SignUpState {
  const ChangeSignUpState(super.model);
}

class OpenSignInState extends SignUpState {
  const OpenSignInState(super.model);
}

class OpenPrivacyPolicyState extends SignUpState {
  const OpenPrivacyPolicyState(super.model);
}

class OpenSignUpWithEmailState extends SignUpState {
  const OpenSignUpWithEmailState(super.model);
}

class OpenHomeState extends SignUpState {
  const OpenHomeState(super.model);
}

class EmailAlreadyInUseState extends SignUpState {
  const EmailAlreadyInUseState(super.model);
}

class GeneralErrorState extends SignUpState {
  const GeneralErrorState(super.model);
}

class OpenSyncPassState extends SignUpState {
  const OpenSyncPassState(super.model);
}

class OpenAuthScreenState extends SignUpState {
  const OpenAuthScreenState(super.model);
}

class SignUpStateModel extends Equatable {
  final TextForm name;
  final EmailForm email;
  final bool alreadySubmitted;
  final String? selectedImg;
  final SignUpPasswordForm password;
  final bool showPassword;
  final FormzSubmissionStatus status;
  final SignUpTypeEnum? signUpType;

  const SignUpStateModel({
    this.name = const TextForm.pure(),
    this.email = const EmailForm.pure(),
    this.alreadySubmitted = false,
    this.selectedImg,
    this.password = const SignUpPasswordForm.pure(),
    this.showPassword = false,
    this.status = FormzSubmissionStatus.initial,
    this.signUpType,
  });

  SignUpStateModel copyWith({
    TextForm? name,
    EmailForm? email,
    SignUpPasswordForm? password,
    bool? alreadySubmitted,
    String? selectedImg,
    bool? showPassword,
    FormzSubmissionStatus? status,
    SignUpTypeEnum? signUpType,
  }) {
    return SignUpStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      selectedImg: selectedImg ?? this.selectedImg,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
      signUpType: signUpType ?? this.signUpType,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        alreadySubmitted,
        selectedImg,
        password,
        showPassword,
        status,
        signUpType,
      ];
}
