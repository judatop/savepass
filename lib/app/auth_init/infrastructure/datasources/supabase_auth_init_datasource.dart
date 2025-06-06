import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabaseAuthInitDatasource implements AuthInitDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseAuthInitDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> checkMasterPassword({
    required String inputSecret,
    required String deviceId,
    required String biometricHash,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.checkMasterPasswordFunction,
        params: {
          'input_secret': inputSecret,
          'device_id_param': deviceId,
          'biometric_hash': biometricHash,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('checkMasterPassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getUserSalt() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.getUserSaltFunction,
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('getUserSalt: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> hasBiometrics({
    required String deviceId,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.hasBiometricsFunction,
        params: {
          'device_id_param': deviceId,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('hasBiometrics: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
