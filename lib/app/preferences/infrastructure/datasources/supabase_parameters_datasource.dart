import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/preferences/domain/datasources/parameters_datasource.dart';
import 'package:savepass/app/preferences/infrastructure/models/card_image_model.dart';
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
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'policy');
      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getPrivacyUrl: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting privacy url'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getTermsUrl() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'terms');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getTermsUrl: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting terms url'),
      );
    }
  }

  @override
  Future<Either<Fail, List<PassImageModel>>> getPassImages() async {
    try {
      final response =
          await supabase.from(DbUtils.passwordsParametersTable).select();

      List<PassImageModel> passImages = response.map((e) {
        PassImageModel model = PassImageModel.fromJson(e);
        return model;
      }).toList();

      final passwordIndex = passImages.indexWhere(
        (element) => element.key.toLowerCase().contains('password'),
      );

      if (passwordIndex != -1) {
        final password = passImages.removeAt(passwordIndex);
        passImages.insert(0, password.copyWith(selected: true));
      }

      return Right(passImages);
    } catch (e, stackTrace) {
      log.severe('getPassImages: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting pass images'),
      );
    }
  }

  @override
  Future<Either<Fail, List<CardImageModel>>> getCardImages() async {
    try {
      final response =
          await supabase.from(DbUtils.cardParametersTable).select();

      List<CardImageModel> cardImgs = response.map((e) {
        CardImageModel model = CardImageModel.fromJson(e);
        return model;
      }).toList();

      return Right(cardImgs);
    } catch (e, stackTrace) {
      log.severe('getCardImages: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting card images'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getAppVersion() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'appVersion');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getAppVersion: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting app version'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getFeatureFlag() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'featureFlag');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getFeatureFlag: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting feature flag'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getAppStoreURL() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'appStoreURL');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getAppStoreURL: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting app store URL'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getPlayStoreURL() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'playStoreURL');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getPlayStoreURL: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting play store URL'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getSavePassDocsURL() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'savepassDocs');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getSavePassDocsURL: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting savepass docs URL'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getSupportMail() async {
    try {
      final response = await supabase
          .from(DbUtils.publicParametersTable)
          .select()
          .eq('key', 'supportMail');

      return Right(response[0]['value'] as String);
    } catch (e, stackTrace) {
      log.severe('getSupportMail: $e', e, stackTrace);
      return Left(
        Fail('Error occurred while getting support mail URL'),
      );
    }
  }
}
