import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/enroll/domain/repositories/enroll_repository.dart';
import 'package:savepass/app/enroll/infrastructure/models/enroll_new_device_model.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/core/utils/device_info.dart';

class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  final EnrollRepository enrollRepository;
  final DeviceInfo deviceInfo;

  EnrollBloc({
    required this.enrollRepository,
    required this.deviceInfo,
  }) : super(const EnrollInitialState()) {
    on<EnrollInitialEvent>(_onEnrollInitialEvent);
    on<SubmitEnrollEvent>(_onSubmitEnrollEvent);
  }

  FutureOr<void> _onEnrollInitialEvent(
    EnrollInitialEvent event,
    Emitter<EnrollState> emit,
  ) async {
    final response = await enrollRepository.getDeviceName();

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        if (r.data == null) {
          emit(
            GeneralErrorState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        emit(
          ChangeEnrollState(
            state.model.copyWith(
              enrolledDevice: r.data!['device_name'],
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _onSubmitEnrollEvent(
    SubmitEnrollEvent event,
    Emitter<EnrollState> emit,
  ) async {
    emit(
      ChangeEnrollState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final deviceId = await deviceInfo.getDeviceId();
    final deviceName = await deviceInfo.getDeviceName();
    final type = deviceInfo.getDeviceType();

    if (deviceId == null) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    final response = await enrollRepository.enrollNewDevice(
      model: EnrollNewDeviceModel(
        deviceId: deviceId,
        deviceName: deviceName,
        type: type,
      ),
    );

    response.fold(
      (l) {
        emit(
          GeneralErrorState(
            state.model.copyWith(status: FormzSubmissionStatus.failure),
          ),
        );
      },
      (r) {
        if (r.data == null) {
          emit(
            GeneralErrorState(
              state.model.copyWith(status: FormzSubmissionStatus.failure),
            ),
          );
          return;
        }

        final profileBloc = Modular.get<ProfileBloc>();
        profileBloc.add(SaveJwtEvent(jwt: r.data!['jwt']));

        emit(
          SuccessEnrolledState(
            state.model.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          ),
        );
      },
    );
  }
}
