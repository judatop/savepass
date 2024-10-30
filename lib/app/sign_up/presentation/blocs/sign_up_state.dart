import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/infrastructure/models/master_password_form.dart';
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

class SyncMasterPasswordState extends SignUpState {
  const SyncMasterPasswordState(super.model);
}

class SignUpStateModel extends Equatable {
  final TextForm name;
  final EmailForm email;
  final MasterPasswordForm masterPassword;
  final bool alreadySubmitted;
  final String? selectedImg;
  final bool showMasterPassword;
  final FormzSubmissionStatus status;
  // final User? userFirebase;
  final SignUpTypeEnum? signUpType;

  const SignUpStateModel({
    this.name = const TextForm.pure(),
    this.email = const EmailForm.pure(),
    this.masterPassword = const MasterPasswordForm.pure(),
    this.alreadySubmitted = false,
    this.selectedImg,
    this.showMasterPassword = false,
    this.status = FormzSubmissionStatus.initial,
    // this.userFirebase,
    this.signUpType,
  });

  SignUpStateModel copyWith({
    TextForm? name,
    EmailForm? email,
    MasterPasswordForm? masterPassword,
    bool? alreadySubmitted,
    String? selectedImg,
    bool? showMasterPassword,
    FormzSubmissionStatus? status,
    // User? userFirebase,
    SignUpTypeEnum? signUpType,
  }) {
    return SignUpStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      masterPassword: masterPassword ?? this.masterPassword,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      selectedImg: selectedImg ?? this.selectedImg,
      showMasterPassword: showMasterPassword ?? this.showMasterPassword,
      status: status ?? this.status,
      // userFirebase: userFirebase ?? this.userFirebase,
      signUpType: signUpType ?? this.signUpType,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        masterPassword,
        alreadySubmitted,
        selectedImg,
        showMasterPassword,
        status,
        // userFirebase,
        signUpType,
      ];
}
