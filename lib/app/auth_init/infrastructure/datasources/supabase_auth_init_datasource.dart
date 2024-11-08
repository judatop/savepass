import 'package:dartz/dartz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/auth_init/domain/datasources/auth_init_datasource.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';

class SupabaseAuthInitDatasource implements AuthInitDatasource {
  final Logger log;

  SupabaseAuthInitDatasource({required this.log});

  @override
  Future<Either<Fail, bool>> checkMasterPassword({
    required String secretUuid,
    required String inputPassword,
  }) async {
    try {
      final response = await supabase.rpc(
        DbUtils.checkMasterPasswordFunction,
        params: {
          'secret_uuid': secretUuid,
          'input_secret': inputPassword,
        },
      );

      return Right(response);
    } catch (e) {
      log.e('checkMasterPassword: $e');
      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }
}
