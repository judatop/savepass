import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Fail, AuthResponse>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
