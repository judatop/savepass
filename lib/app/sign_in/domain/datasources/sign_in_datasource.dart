import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SignInDatasource {
  Future<Either<Fail, AuthResponse>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
