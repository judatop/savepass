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
      await supabase.from(DbUtils.passwordsTable).insert({
        'user_id': supabase.auth.currentUser!.id,
        'type_img': model.passImg,
        'name': model.passName,
        'username': model.passUser,
        'password': model.passPassword,
        'description': model.passDesc,
        'domain': model.passDomain,
      });

      return const Right(unit);
    } catch (e) {
      log.e('insertPassword: $e');
      return Left(
        Fail('Error occurred while inserting password'),
      );
    }
  }
}
