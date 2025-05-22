import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthDatasource {
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Fail, AuthResponse>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Fail, Unit>> recoveryPassword({
    required String email,
  });

   Future<Either<Fail, UserResponse>> updateNewPassword({
    required String password,
  });
}
