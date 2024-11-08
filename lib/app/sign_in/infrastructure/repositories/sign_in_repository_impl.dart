import 'package:dartz/dartz.dart';
import 'package:savepass/app/sign_in/domain/datasources/sign_in_datasource.dart';
import 'package:savepass/app/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInRepositoryImpl implements SignInRepository {
  final SignInDatasource datasource;

  SignInRepositoryImpl({required this.datasource});

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
}
