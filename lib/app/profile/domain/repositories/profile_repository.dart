import 'package:dartz/dartz.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Fail, String>> uploadAvatar(String imgPath);

  Future<Either<Fail, Unit>> updateProfile({
    String? displayName,
    String? avatarUuid,
  });

  Future<Either<Fail, Unit>> updateMasterPasswordUuid({
    required String uuid,
  });

  Future<Either<Fail, bool>> checkIfHasMasterPassword();

  Future<Either<Fail, ProfileEntity>> getProfile();

  Future<Either<Fail, String?>> isEmailExists(String email);
}
