import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/password/domain/datasources/password_datasource.dart';
import 'package:savepass/app/password/infrastructure/models/password_model.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabasePasswordDatasource implements PasswordDatasource {
  final Logger log;

  SupabasePasswordDatasource({required this.log});

  @override
  Future<Either<Fail, Unit>> insertPassword(PasswordModel model) async {
    try {
      await supabase.rpc(
        DbUtils.insertPasswordFunction,
        params: {
          'type_img': model.typeImg,
          'name': model.name,
          'username': model.username,
          'password': model.password,
          'description': model.description,
          'domain': model.domain,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('insertPassword: $e');
      return Left(
        Fail('Error occurred while inserting password'),
      );
    }
  }

  @override
  Future<Either<Fail, List<PasswordModel>>> getPasswords() async {
    try {
      final response =
          await supabase.from(DbUtils.passwordsTable).select().order(
                'created_at',
                ascending: false,
              );

      List<PasswordModel> passwords = response.map((e) {
        PasswordModel model = PasswordModel.fromJson(e);
        return model;
      }).toList();

      return Right(passwords);
    } catch (e) {
      log.e('getPasswords: $e');
      return Left(
        Fail('Error occurred while gettings passwords'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getPassword(String passwordId) async {
    try {
      final response = await supabase.rpc(
        DbUtils.getPasswordFunction,
        params: {
          'secret_uuid': passwordId,
        },
      );

      if (response == null) {
        return Left(Fail('Password not found'));
      }

      return Right(response as String);
    } catch (e) {
      log.e('getPassword: $e');
      return Left(
        Fail('Error occurred while getting the password'),
      );
    }
  }
}
