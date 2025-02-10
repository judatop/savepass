import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/form/text_form.dart';

abstract class PassReportState extends Equatable {
  final PasswordReportStateModel model;

  const PassReportState(this.model);

  @override
  List<Object> get props => [model];
}

class PassReportInitialState extends PassReportState {
  const PassReportInitialState() : super(const PasswordReportStateModel());
}

class ChangePassReportState extends PassReportState {
  const ChangePassReportState(super.model);
}

class GeneralErrorState extends PassReportState {
  const GeneralErrorState(super.model);
}

class LoadingPasswordState extends PassReportState {
  const LoadingPasswordState(super.model);
}

class PasswordReportStateModel extends Equatable {
  final TextForm searchForm;
  final FormzSubmissionStatus status;
  final List<PasswordModel> passwords;

  const PasswordReportStateModel({
    this.searchForm = const TextForm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.passwords = const [],
  });

  PasswordReportStateModel copyWith({
    TextForm? searchForm,
    FormzSubmissionStatus? status,
    List<PasswordModel>? passwords,
  }) {
    return PasswordReportStateModel(
      searchForm: searchForm ?? this.searchForm,
      status: status ?? this.status,
      passwords: passwords ?? this.passwords,
    );
  }

  @override
  List<Object?> get props => [
        searchForm,
        status,
        passwords,
      ];
}
