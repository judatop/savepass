import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/enroll/domain/datasources/enroll_datasource.dart';
import 'package:savepass/app/enroll/infrastructure/models/enroll_new_device_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabaseEnrollDatasource implements EnrollDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseEnrollDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> getDeviceName() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.deviceNameFunction,
      );

      return Right(response);
    } catch (e) {
      log.e('getDeviceName: $e');
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> enrollNewDevice({
    required EnrollNewDeviceModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.enrollNewDeviceFunction,
        params: model.toJson(),
      );

      return Right(response);
    } catch (e) {
      log.e('enrollNewDevice: $e');
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
