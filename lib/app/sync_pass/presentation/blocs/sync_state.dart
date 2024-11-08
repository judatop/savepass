import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/sign_up/infrastructure/models/master_password_form.dart';

abstract class SyncState extends Equatable {
  final SyncStateModel model;

  const SyncState(this.model);

  @override
  List<Object> get props => [model];
}

class SyncInitialState extends SyncState {
  const SyncInitialState() : super(const SyncStateModel());
}

class ChangeSyncState extends SyncState {
  const ChangeSyncState(super.model);
}

class OpenHomeState extends SyncState {
  const OpenHomeState(super.model);
}

class GeneralErrorState extends SyncState {
  const GeneralErrorState(super.model);
}

class SyncStateModel extends Equatable {
  final MasterPasswordForm masterPassword;
  final bool showPassword;
  final FormzSubmissionStatus status;
  final bool alreadySubmitted;

  const SyncStateModel({
    this.masterPassword = const MasterPasswordForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.alreadySubmitted = false,
    this.showPassword = false,
  });

  SyncStateModel copyWith({
    MasterPasswordForm? masterPassword,
    FormzSubmissionStatus? status,
    bool? alreadySubmitted,
    bool? showPassword,
  }) {
    return SyncStateModel(
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
