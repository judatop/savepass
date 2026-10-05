import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/enroll/infrastructure/models/device_model.dart';

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
  final List<DeviceModel> devices;
  final FormzSubmissionStatus status;

  const EnrollStateModel({
    this.devices = const <DeviceModel>[],
    this.status = FormzSubmissionStatus.initial,
  });

  EnrollStateModel copyWith({
    List<DeviceModel>? devices,
    FormzSubmissionStatus? status,
  }) {
    return EnrollStateModel(
      devices: devices ?? this.devices,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        devices,
        status,
      ];
}
