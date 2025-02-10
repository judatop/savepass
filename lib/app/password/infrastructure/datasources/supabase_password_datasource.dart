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
                'updated_at',
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

  @override
  Future<Either<Fail, PasswordModel>> getPasswordModel(
    String passwordId,
  ) async {
    try {
      final response = await supabase
          .from(DbUtils.passwordsTable)
          .select()
          .eq('id', passwordId);

      PasswordModel password = PasswordModel.fromJson(response.first);

      return Right(password);
    } catch (e) {
      log.e('getPasswordModel: $e');
      return Left(
        Fail('Error occurred while getting your password model'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> editPassword(
    PasswordModel model,
    String clearPassword,
  ) async {
    try {
      await supabase.rpc(
        DbUtils.editPasswordFunction,
        params: {
          'type_img_param': model.typeImg,
          'name_param': model.name,
          'username_param': model.username,
          'clear_password_param': clearPassword,
          'description_param': model.description,
          'domain_param': model.domain,
          'password_id_param': model.id,
          'vault_id_param': model.password,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('editPassword: $e');
      return Left(
        Fail('Error occurred while editing password'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> deletePassword(
    String passwordId,
    String vaultId,
  ) async {
    try {
      await supabase.rpc(
        DbUtils.deletepasswordFunction,
        params: {
          'password_id_param': passwordId,
          'vault_id_param': vaultId,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('deletePassword: $e');
      return Left(
        Fail('Error occurred while deleting your password'),
      );
    }
  }

  @override
  Future<Either<Fail, List<PasswordModel>>> searchPasswords(String search) async {
    try {
      final response = await supabase.rpc(
        DbUtils.searchPasswordFunction,
        params: {
          'search': search,
        },
      );

      if (response == null) {
        return Left(Fail('Error in search'));
      }

      List<PasswordModel> items = (response as List<dynamic>).map((e) {
        return PasswordModel.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Right(items);
    } catch (e) {
      log.e('search: $e');
      return Left(
        Fail('Error occurred while searching'),
      );
    }
  }
}
