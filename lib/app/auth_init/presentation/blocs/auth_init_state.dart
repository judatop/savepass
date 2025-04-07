import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/core/form/password_form.dart';

abstract class AuthInitState extends Equatable {
  final AuthInitStateModel model;

  const AuthInitState(this.model);

  @override
  List<Object> get props => [model];
}

class AuthInitInitialState extends AuthInitState {
  const AuthInitInitialState() : super(const AuthInitStateModel());
}

class AuthInitStateLoadingState extends AuthInitState {
  const AuthInitStateLoadingState(super.model);
}

class ChangeAuthInitState extends AuthInitState {
  const ChangeAuthInitState(super.model);
}

class OpenHomeState extends AuthInitState {
  const OpenHomeState(super.model);
}

class RefreshSuccessState extends AuthInitState {
  const RefreshSuccessState(super.model);
}

class InvalidMasterPasswordState extends AuthInitState {
  const InvalidMasterPasswordState(super.model);
}

class GeneralErrorState extends AuthInitState {
  const GeneralErrorState(super.model);
}

class DeviceAlreadyEnrolledState extends AuthInitState {
  const DeviceAlreadyEnrolledState(super.model);
}

class DeviceNotEnrolledState extends AuthInitState {
  const DeviceNotEnrolledState(super.model);
}

class AuthInitStateModel extends Equatable {
  final PasswordForm password;
  final bool alreadySubmitted;
  final bool showPassword;
  final FormzSubmissionStatus statusProfile;
  final FormzSubmissionStatus statusBiometrics;
  final FormzSubmissionStatus status;
  final ProfileEntity? profile;
  final bool hasBiometricsSaved;
  final bool canAuthenticateWithBiometrics;
  final bool refreshAuth;

  const AuthInitStateModel({
    this.password = const PasswordForm.pure(),
    this.alreadySubmitted = false,
    this.showPassword = false,
    this.statusProfile = FormzSubmissionStatus.initial,
    this.statusBiometrics = FormzSubmissionStatus.initial,
    this.status = FormzSubmissionStatus.initial,
    this.profile,
    this.hasBiometricsSaved = false,
    this.canAuthenticateWithBiometrics = false,
    this.refreshAuth = false,
  });

  AuthInitStateModel copyWith({
    ProfileEntity? profile,
    PasswordForm? password,
    bool? alreadySubmitted,
    bool? showPassword,
    FormzSubmissionStatus? statusProfile,
    FormzSubmissionStatus? statusBiometrics,
    FormzSubmissionStatus? status,
    bool? hasBiometricsSaved,
    bool? canAuthenticateWithBiometrics,
    bool? refreshAuth,
  }) {
    return AuthInitStateModel(
      password: password ?? this.password,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      showPassword: showPassword ?? this.showPassword,
      statusProfile: statusProfile ?? this.statusProfile,
      statusBiometrics: statusBiometrics ?? this.statusBiometrics,
      profile: profile ?? this.profile,
      hasBiometricsSaved: hasBiometricsSaved ?? this.hasBiometricsSaved,
      canAuthenticateWithBiometrics:
          canAuthenticateWithBiometrics ?? this.canAuthenticateWithBiometrics,
      status: status ?? this.status,
      refreshAuth: refreshAuth ?? this.refreshAuth,
    );
  }

  @override
  List<Object?> get props => [
        password,
        alreadySubmitted,
        showPassword,
        statusProfile,
        statusBiometrics,
        status,
        profile,
        hasBiometricsSaved,
        canAuthenticateWithBiometrics,
        refreshAuth,
      ];
}
