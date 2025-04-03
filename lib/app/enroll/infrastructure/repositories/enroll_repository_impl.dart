

import 'package:dartz/dartz.dart';
import 'package:savepass/app/enroll/domain/datasources/enroll_datasource.dart';
import 'package:savepass/app/enroll/domain/repositories/enroll_repository.dart';
import 'package:savepass/app/enroll/infrastructure/models/enroll_new_device_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

class EnrollRepositoryImpl implements EnrollRepository {

  final EnrollDatasource datasource;

  EnrollRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, SavePassResponseModel>> getDeviceName() async {
    return await datasource.getDeviceName();
  }
  
  @override
  Future<Either<Fail, SavePassResponseModel>> enrollNewDevice({
    required EnrollNewDeviceModel model,
  }) async {
    return await datasource.enrollNewDevice(model: model);
  }

  

}