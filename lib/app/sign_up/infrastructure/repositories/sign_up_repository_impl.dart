import 'package:dartz/dartz.dart';
import 'package:savepass/app/sign_up/domain/datasources/sign_up_datasource.dart';
import 'package:savepass/app/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpDatasource datasource;

  SignUpRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return datasource.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
