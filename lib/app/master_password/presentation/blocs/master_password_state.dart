import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sync_pass/infrastructure/models/master_password_form.dart';
import 'package:savepass/core/form/password_form.dart';

abstract class MasterPasswordState extends Equatable {
  final MasterPasswordStateModel model;

  const MasterPasswordState(this.model);

  @override
  List<Object> get props => [model];
}

class MasterPasswordInitialState extends MasterPasswordState {
  const MasterPasswordInitialState() : super(const MasterPasswordStateModel());
}

class ChangeMasterPasswordState extends MasterPasswordState {
  const ChangeMasterPasswordState(super.model);
}

class MasterPasswordUpdatedState extends MasterPasswordState {
  const MasterPasswordUpdatedState(super.model);
}

class GeneralErrorState extends MasterPasswordState {
  const GeneralErrorState(super.model);
}

class InvalidMasterPasswordState extends MasterPasswordState {
  const InvalidMasterPasswordState(super.model);
}

class SamePasswordsMasterPasswordState extends MasterPasswordState {
  const SamePasswordsMasterPasswordState(super.model);
}

class PasswordsMismatchState extends MasterPasswordState{
  const PasswordsMismatchState(super.model);
}

class MasterPasswordStateModel extends Equatable {
  final PasswordForm oldPassword;
  final MasterPasswordForm newPassword;
  final MasterPasswordForm repeatNewPassword;
  final bool showOldPassword;
  final bool showNewPassword;
  final bool showRepeatNewPassword;
  final FormzSubmissionStatus status;
  final bool alreadySubmitted;

  const MasterPasswordStateModel({
    this.oldPassword = const PasswordForm.pure(),
    this.newPassword = const MasterPasswordForm.pure(),
    this.repeatNewPassword = const MasterPasswordForm.pure(),
    this.showOldPassword = false,
    this.showNewPassword = false,
    this.showRepeatNewPassword = false,
    this.status = FormzSubmissionStatus.initial,
    this.alreadySubmitted = false,
  });

  MasterPasswordStateModel copyWith({
    PasswordForm? oldPassword,
    MasterPasswordForm? newPassword,
    MasterPasswordForm? repeatNewPassword,
    bool? showOldPassword,
    bool? showNewPassword,
    bool? showRepeatNewPassword,
    FormzSubmissionStatus? status,
    bool? alreadySubmitted,
  }) {
    return MasterPasswordStateModel(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      repeatNewPassword: repeatNewPassword ?? this.repeatNewPassword,
      showOldPassword: showOldPassword ?? this.showOldPassword,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      showRepeatNewPassword:
          showRepeatNewPassword ?? this.showRepeatNewPassword,
      status: status ?? this.status,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
    );
  }

  @override
  List<Object?> get props => [
        oldPassword,
        newPassword,
        repeatNewPassword,
        showOldPassword,
        showNewPassword,
        showRepeatNewPassword,
        status,
        alreadySubmitted,
      ];
}
