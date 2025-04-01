import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';

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

class BiometricStateModel extends Equatable {
  final MasterPasswordForm masterPassword;
  final bool showPassword;
  final FormzSubmissionStatus status;
  final bool alreadySubmitted;

  const BiometricStateModel({
    this.masterPassword = const MasterPasswordForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.alreadySubmitted = false,
    this.showPassword = false,
  });

  BiometricStateModel copyWith({
    MasterPasswordForm? masterPassword,
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
