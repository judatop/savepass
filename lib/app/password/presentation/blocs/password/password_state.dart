import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
import 'package:savepass/core/form/password_form.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class PasswordState extends Equatable {
  final PasswordStateModel model;

  const PasswordState(this.model);

  @override
  List<Object> get props => [model];
}

class PasswordInitialState extends PasswordState {
  const PasswordInitialState() : super(const PasswordStateModel());
}

class ChangePasswordState extends PasswordState {
  const ChangePasswordState(super.model);
}

class GeneralErrorState extends PasswordState {
  const GeneralErrorState(super.model);
}

class LoadingPasswordState extends PasswordState {
  const LoadingPasswordState(super.model);
}

class GeneratedPasswordState extends PasswordState {
  const GeneratedPasswordState(super.model);
}

class PasswordCreatedState extends PasswordState {
  const PasswordCreatedState(super.model);
}

class ErrorLoadingPasswordState extends PasswordState {
  const ErrorLoadingPasswordState(super.model);
}

class PassCopiedState extends PasswordState {
  const PassCopiedState(super.model);
}

class UserCopiedState extends PasswordState {
  const UserCopiedState(super.model);
}

class PasswordDeletedState extends PasswordState {
  const PasswordDeletedState(super.model);
}

class ReachedPasswordsState extends PasswordState{
  const ReachedPasswordsState(super.model);
}

class PasswordStateModel extends Equatable {
  final TextForm name;
  final TextForm email;
  final PasswordForm password;
  final TextForm singleTag;
  final String workspace;
  final TextForm desc;
  final bool alreadySubmitted;
  final FormzSubmissionStatus status;
  final bool showPassword;
  final List<PassImageModel> images;
  final String? imgUrl;
  final PasswordModel? passwordSelected;
  final bool isUpdating;

  const PasswordStateModel({
    this.name = const TextForm.pure(),
    this.email = const TextForm.pure(),
    this.password = const PasswordForm.pure(),
    this.singleTag = const TextForm.pure(),
    this.workspace = '',
    this.desc = const TextForm.pure(),
    this.alreadySubmitted = false,
    this.status = FormzSubmissionStatus.initial,
    this.showPassword = false,
    this.images = const [],
    this.imgUrl,
    this.passwordSelected,
    this.isUpdating = false,
  });

  PasswordStateModel copyWith({
    TextForm? name,
    TextForm? email,
    PasswordForm? password,
    TextForm? singleTag,
    String? workspace,
    TextForm? desc,
    bool? alreadySubmitted,
    FormzSubmissionStatus? status,
    bool? showPassword,
    List<PassImageModel>? images,
    String? imgUrl,
    PasswordModel? passwordSelected,
    bool? isUpdating,
  }) {
    return PasswordStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      singleTag: singleTag ?? this.singleTag,
      workspace: workspace ?? this.workspace,
      desc: desc ?? this.desc,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      images: images ?? this.images,
      imgUrl: imgUrl ?? this.imgUrl,
      passwordSelected: passwordSelected ?? this.passwordSelected,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        singleTag,
        workspace,
        desc,
        alreadySubmitted,
        status,
        showPassword,
        images,
        imgUrl,
        passwordSelected,
        isUpdating,
      ];
}
