import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SignUpDatasource {
  Future<Either<Fail, AuthResponse>> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
}
