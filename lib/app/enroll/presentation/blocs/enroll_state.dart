import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

abstract class EnrollState extends Equatable {
  final EnrollStateModel model;

  const EnrollState(this.model);

  @override
  List<Object> get props => [model];
}

class EnrollInitialState extends EnrollState {
  const EnrollInitialState() : super(const EnrollStateModel());
}

class ChangeEnrollState extends EnrollState {
  const ChangeEnrollState(super.model);
}

class GeneralErrorState extends EnrollState {
  const GeneralErrorState(super.model);
}

class SuccessEnrolledState extends EnrollState {
  const SuccessEnrolledState(super.model);
}

class EnrollStateModel extends Equatable {
  final String enrolledDevice;
  final FormzSubmissionStatus status;

  const EnrollStateModel({
    this.enrolledDevice = '',
    this.status = FormzSubmissionStatus.initial,
  });

  EnrollStateModel copyWith({
    String? enrolledDevice,
    FormzSubmissionStatus? status,
  }) {
    return EnrollStateModel(
      enrolledDevice: enrolledDevice ?? this.enrolledDevice,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        enrolledDevice,
        status,
      ];
}
