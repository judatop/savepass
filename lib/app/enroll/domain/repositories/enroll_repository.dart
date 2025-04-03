import 'package:dartz/dartz.dart';
import 'package:savepass/app/enroll/infrastructure/models/enroll_new_device_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class EnrollRepository {
  Future<Either<Fail, SavePassResponseModel>> getDeviceName();
  Future<Either<Fail, SavePassResponseModel>> enrollNewDevice({
    required EnrollNewDeviceModel model,
  });
}
