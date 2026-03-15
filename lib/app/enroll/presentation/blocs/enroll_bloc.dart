import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:formz/formz.dart';
import 'package:savepass/app/enroll/domain/repositories/enroll_repository.dart';
import 'package:savepass/app/enroll/infrastructure/models/device_model.dart';
import 'package:savepass/app/enroll/infrastructure/models/enroll_new_device_model.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_event.dart';
import 'package:savepass/app/enroll/presentation/blocs/enroll_state.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:savepass/app/profile/presentation/blocs/profile/profile_event.dart';
import 'package:savepass/core/api/api_codes.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/utils/device_info.dart';

class EnrollBloc extends Bloc<EnrollEvent, EnrollState> {
  final EnrollRepository enrollRepository;
  final DeviceInfo deviceInfo;

  EnrollBloc({
    required this.enrollRepository,
    required this.deviceInfo,
  }) : super(const EnrollInitialState()) {
    on<EnrollInitialEvent>(_onEnrollInitialEvent);
    on<EnrollNewDeviceEvent>(_onEnrollNewDeviceEvent);
  }

  FutureOr<void> _onEnrollInitialEvent(
    EnrollInitialEvent event,
    Emitter<EnrollState> emit,
  ) async {
    final response = await enrollRepository.getCurrentSessions();
    late final SavePassResponseModel? savePassResponse;
    response.fold(
      (l) {
        savePassResponse = null;
      },
      (r) {
        savePassResponse = r;
      },
    );

    if (savePassResponse == null ||
        savePassResponse?.code != ApiCodes.success) {
      emit(
        GeneralErrorState(
          state.model.copyWith(status: FormzSubmissionStatus.failure),
        ),
      );
      return;
    }

    List<DeviceModel> devices = [];
    final devicesData = savePassResponse?.data;

    if (devicesData != null && devicesData['list'] != null) {
      final devicesList = devicesData['list'] as List;

      final newResult =
          devicesList.map((e) => DeviceModel.fromJson(e)).toList();

      devices.addAll(newResult);
    }

    emit(
      ChangeEnrollState(
        state.model.copyWith(
          devices: devices,
        ),
      ),
    );
  }

  FutureOr<void> _onEnrollNewDeviceEvent(
    EnrollNewDeviceEvent event,
    Emitter<EnrollState> emit,
  ) async {
    emit(
      ChangeEnrollState(
        state.model.copyWith(
          status: FormzSubmissionStatus.inProgress,
        ),
      ),
    );

    final deviceIdToDisable = event.deviceId;
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
        deviceIdToDisable: deviceIdToDisable,
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
