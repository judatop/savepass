import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/sign_in/domain/datasources/sign_in_datasource.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSignInDatasource implements SignInDatasource {
  final Logger log;

  SupabaseSignInDatasource({required this.log});

  @override
  Future<Either<Fail, AuthResponse>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user?.id == null) {
        throw Exception('User id is null');
      }

      return Right(response);
    } catch (e) {
      log.e('signInWithEmailAndPassword: $e');

      if (e is AuthApiException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }
}
