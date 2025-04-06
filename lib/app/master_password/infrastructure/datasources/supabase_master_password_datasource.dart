import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/master_password/domain/datasources/master_password_datasource.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_master_password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabaseMasterPasswordDatasource implements MasterPasswordDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseMasterPasswordDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> updateMasterPassword({
    required UpdateMasterPasswordModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.updateMasterPassword,
        params: model.toJson(),
      );

      return Right(response);
    } catch (e) {
      log.e('insertMasterPassword: $e');
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
