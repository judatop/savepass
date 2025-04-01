import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/biometric/domain/datasources/biometric_datasource.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabaseBiometricDatasource implements BiometricDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseBiometricDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> enrollBiometric({
    required String inputSecret,
    required String deviceId,
  }) async {
     try {
      final response = await middleware.doHttp(
        rpc: DbUtils.enrollBiometricFunction,
        params: {
          'input_secret': inputSecret,
          'device_id_param': deviceId,
        },
      );

      return Right(response);
    } catch (e) {
      log.e('enrollBiometric: $e');
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
