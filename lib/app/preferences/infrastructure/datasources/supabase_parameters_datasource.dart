import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/models/pass_image_model.dart';
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

  @override
  Future<Either<Fail, List<PassImageModel>>> getPassImages() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParameters)
          .select()
          .ilike('key', 'pass%');

      List<PassImageModel> passImages = response.map((e) {
        PassImageModel model = PassImageModel.fromJson(e);
        return model;
      }).toList();

      final passwordIndex =
          passImages.indexWhere((element) => element.key.contains('password'));
      if (passwordIndex != -1) {
        final password = passImages.removeAt(passwordIndex);
        passImages.insert(0, password);
      }

      for (int i = 0; i < passImages.length; i++) {
        if (i == 0) {
          passImages[i] = passImages[i].copyWith(selected: true);
          break;
        }
      }

      return Right(passImages);
    } catch (e) {
      log.e('getPassImages: $e');
      return Left(
        Fail('Error occurred while getting pass images'),
      );
    }
  }
}
