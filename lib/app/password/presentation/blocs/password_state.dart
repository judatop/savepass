import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
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

class PasswordStateModel extends Equatable {
  final TextForm name;
  final TextForm email;
  final PasswordForm password;
  final List<TextForm> tags;
  final TextForm singleTag;
  final String workspace;
  final TextForm desc;
  final bool alreadySubmitted;
  final FormzSubmissionStatus status;
  final bool showPassword;
  final List<PassImageModel> images;
  final bool typeAuto;

  const PasswordStateModel({
    this.name = const TextForm.pure(),
    this.email = const TextForm.pure(),
    this.password = const PasswordForm.pure(),
    this.tags = const [],
    this.singleTag = const TextForm.pure(),
    this.workspace = '',
    this.desc = const TextForm.pure(),
    this.alreadySubmitted = false,
    this.status = FormzSubmissionStatus.initial,
    this.showPassword = false,
    this.images = const [],
    this.typeAuto = true,
  });

  PasswordStateModel copyWith({
    TextForm? name,
    TextForm? email,
    PasswordForm? password,
    List<TextForm>? tags,
    TextForm? singleTag,
    String? workspace,
    TextForm? desc,
    bool? alreadySubmitted,
    FormzSubmissionStatus? status,
    bool? showPassword,
    List<PassImageModel>? images,
    bool? typeAuto,
  }) {
    return PasswordStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      tags: tags ?? this.tags,
      singleTag: singleTag ?? this.singleTag,
      workspace: workspace ?? this.workspace,
      desc: desc ?? this.desc,
      alreadySubmitted: alreadySubmitted ?? this.alreadySubmitted,
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      images: images ?? this.images,
      typeAuto: typeAuto ?? this.typeAuto,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        tags,
        singleTag,
        workspace,
        desc,
        alreadySubmitted,
        status,
        showPassword,
        images,
        typeAuto,
      ];
}
