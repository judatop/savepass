import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabaseParametersDatasource implements ParametersDatasource {
  final Logger log;

  SupabaseParametersDatasource({required this.log});

  @override
  Future<Either<Fail, String>> getPrivacyUrl() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParameters)
          .select()
          .eq('key', 'policy');
      return Right(response[0]['value'] as String);
    } catch (e) {
      log.e('getPrivacyUrl: $e');
      return Left(
        Fail('Error occurred while getting privacy url'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getTermsUrl() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParameters)
          .select()
          .eq('key', 'terms');

      return Right(response[0]['value'] as String);
    } catch (e) {
      log.e('getTermsUrl: $e');
      return Left(
        Fail('Error occurred while getting terms url'),
      );
    }
  }
}
