import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabasePasswordDatasource implements PasswordDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabasePasswordDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> insertPassword({
    required PasswordModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.insertPasswordFunction,
        params: model.toInsertJson(),
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('insertPassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> editPassword({
    required PasswordModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.editPasswordFunction,
        params: model.toEditJson(),
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('editPassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> deletePassword({
    required String passwordId,
    required String vaultId,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.deletepasswordFunction,
        params: {
          'password_id_param': passwordId,
          'vault_id_param': vaultId,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('deletePassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getPasswords() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.getPasswordsFunction,
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('getPasswords: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getPasswordById({
    required String passwordId,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.getPasswordByIdFunction,
        params: {
          'password_id_param': passwordId,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('getPasswordById: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> searchPasswords({
    required String search,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.searchPasswordFunction,
        params: {
          'search_param': search,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('searchPasswords: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
