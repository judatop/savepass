import 'package:dartz/dartz.dart';
import 'package:savepass/app/auth/domain/datasources/auth_datasource.dart';
import 'package:savepass/app/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, AuthResponse>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await datasource.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<Either<Fail, Unit>> recoveryPassword({required String email}) async {
    return await datasource.recoveryPassword(
      email: email,
    );
  }

  @override
  Future<Either<Fail, UserResponse>> updateNewPassword({
    required String password,
  }) async {
    return await datasource.updateNewPassword(
      password: password,
    );
  }
}
