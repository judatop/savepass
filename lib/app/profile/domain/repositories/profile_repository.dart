import 'package:dartz/dartz.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/app/profile/infraestructure/models/insert_master_password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class ProfileRepository {
  Future<Either<Fail, String>> uploadAvatar(String imgPath);

  Future<Either<Fail, Unit>> updateProfile({
    String? displayName,
    String? avatarUuid,
  });

  Future<Either<Fail, SavePassResponseModel>> insertMasterPassword({
    required InsertMasterPasswordModel model,
  });

  Future<Either<Fail, SavePassResponseModel>> checkIfHasMasterPassword();

  Future<Either<Fail, ProfileEntity>> getProfile();

  Future<Either<Fail, SavePassResponseModel>> isEmailExists({
    required String email,
  });

  Future<Either<Fail, SavePassResponseModel>> deleteAccount();
}
