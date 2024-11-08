import 'package:dartz/dartz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/sign_up/domain/datasources/sign_up_datasource.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSignUpDatasource implements SignUpDatasource {
  final Logger log;

  SupabaseSignUpDatasource({required this.log});

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

      return Right(response);
    } catch (e) {
      log.e('signUpWithEmailAndPassword: $e');
      return Left(
        Fail('Error occurred while signing up with email and password'),
      );
    }
  }
}
