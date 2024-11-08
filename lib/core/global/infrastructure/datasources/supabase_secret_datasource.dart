import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/core/global/domain/datasources/secret_datasource.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabaseSecretDatasource implements SecretDatasource {
  final Logger log;

  SupabaseSecretDatasource({required this.log});

  @override
  Future<Either<Fail, String>> addSecret({
    required String secret,
    required String name,
  }) async {
    try {
      final secretUuid = await supabase.rpc(
        DbUtils.addSecretFunction,
        params: {
          'secret': secret,
          'name': name,
        },
      );

      if (secretUuid == null) {
        throw Exception('Secret not found');
      }

      return Right(secretUuid);
    } catch (e) {
      log.e('addSecret: $e');
      return Left(
        Fail('Error occurred while adding the secret'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getSecret({required String secretUuid}) async {
    try {
      final decodedSecret = await supabase.rpc(
        DbUtils.getSecretFunction,
        params: {
          'secret_uuid': secretUuid,
        },
      );

      if (decodedSecret == null) {
        throw Exception('Secret not found');
      }

      return Right(decodedSecret);
    } catch (e) {
      log.e('getSecret: $e');
      return Left(
        Fail('Error occurred while getting the secret'),
      );
    }
  }
}
