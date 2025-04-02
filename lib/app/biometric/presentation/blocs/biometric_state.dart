import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/core/form/password_form.dart';

abstract class BiometricState extends Equatable {
  final BiometricStateModel model;

  const BiometricState(this.model);

  @override
  List<Object> get props => [model];
}

class BiometricInitialState extends BiometricState {
  const BiometricInitialState() : super(const BiometricStateModel());
}

class ChangeBiometricState extends BiometricState {
  const ChangeBiometricState(super.model);
}

class GeneralErrorState extends BiometricState {
  const GeneralErrorState(super.model);
}

class InvalidMasterPasswordState extends BiometricState {
  const InvalidMasterPasswordState(super.model);
}

class EnrolledSuccessfulState extends BiometricState{
  const EnrolledSuccessfulState(super.model);
}

class BiometricStateModel extends Equatable {
  final PasswordForm masterPassword;
  final bool showPassword;
  final FormzSubmissionStatus status;
  final bool alreadySubmitted;

  const BiometricStateModel({
    this.masterPassword = const PasswordForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.alreadySubmitted = false,
    this.showPassword = false,
  });

  BiometricStateModel copyWith({
    PasswordForm? masterPassword,
    FormzSubmissionStatus? status,
    bool? alreadySubmitted,
    bool? showPassword,
  }) {
    return BiometricStateModel(
      masterPassword: masterPassword ?? this.masterPassword,
      status: status ?? this.status,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      showPassword: showPassword ?? this.showPassword,
    );
  }

  @override
  List<Object?> get props => [
        masterPassword,
        status,
        alreadySubmitted,
        showPassword,
      ];
}
