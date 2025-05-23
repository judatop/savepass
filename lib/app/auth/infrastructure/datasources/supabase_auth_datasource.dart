import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/auth/domain/datasources/auth_datasource.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDatasource implements AuthDatasource {
  final Logger log;

  SupabaseAuthDatasource({required this.log});

  @override
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user?.id == null) {
        throw Exception('User id is null');
      }

      if (response.user?.userMetadata?.isEmpty ?? false) {
        return Left(Fail(SnackBarErrors.userAlreadyExists));
      }

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('signUpWithEmailAndPassword: $e', e, stackTrace);

      if (e is AuthApiException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      return Left(
        Fail('Error occurred while signing up with email and password'),
      );
    }
  }

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
    } catch (e, stackTrace) {
      log.severe('signInWithEmailAndPassword: $e', e, stackTrace);

      if (e is AuthApiException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> recoveryPassword({
    required String email,
  }) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
      );

      return const Right(unit);
    } catch (e, stackTrace) {
      log.severe('recoveryPassword: $e', e, stackTrace);

      if (e is AuthApiException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }

  @override
  Future<Either<Fail, UserResponse>> updateNewPassword({
    required String password,
  }) async {
    try {
      final response =
          await supabase.auth.updateUser(UserAttributes(password: password));

      if (response.user?.id == null) {
        throw Exception('User id is null');
      }

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('updateNewPassword: $e', e, stackTrace);

      if (e is AuthApiException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      if (e is AuthException) {
        return Left(Fail(e.code ?? SnackBarErrors.generalErrorCode));
      }

      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }
}
