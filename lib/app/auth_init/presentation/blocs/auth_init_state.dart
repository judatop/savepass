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

class InvalidMasterPasswordState extends AuthInitState {
  const InvalidMasterPasswordState(super.model);
}

class GeneralErrorState extends AuthInitState {
  const GeneralErrorState(super.model);
}

class AuthInitStateModel extends Equatable {
  final PasswordForm password;
  final bool alreadySubmitted;
  final bool showPassword;
  final FormzSubmissionStatus status;
  final ProfileEntity? profile;

  const AuthInitStateModel({
    this.password = const PasswordForm.pure(),
    this.alreadySubmitted = false,
    this.showPassword = false,
    this.status = FormzSubmissionStatus.initial,
    this.profile,
  });

  AuthInitStateModel copyWith({
    ProfileEntity? profile,
    PasswordForm? password,
    bool? alreadySubmitted,
    bool? showPassword,
    FormzSubmissionStatus? status,
  }) {
    return AuthInitStateModel(
      password: password ?? this.password,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [
        password,
        alreadySubmitted,
        showPassword,
        status,
        profile,
      ];
}
