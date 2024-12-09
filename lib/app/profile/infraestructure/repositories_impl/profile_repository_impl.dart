import 'package:dartz/dartz.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, String>> uploadAvatar(String imgPath) async {
    return await datasource.uploadAvatar(imgPath);
  }

  @override
  Future<Either<Fail, Unit>> updateProfile({
    String? displayName,
    String? avatarUuid,
  }) async {
    return await datasource.updateProfile(
      displayName: displayName,
      avatarUuid: avatarUuid,
    );
  }

  @override
  Future<Either<Fail, Unit>> insertMasterPassword({
    required String masterPassword,
    required String name,
  }) async {
    return await datasource.insertMasterPassword(
      masterPassword: masterPassword,
      name: name,
    );
  }

  @override
  Future<Either<Fail, bool>> checkIfHasMasterPassword() async {
    return await datasource.checkIfHasMasterPassword();
  }

  @override
  Future<Either<Fail, ProfileEntity>> getProfile() async {
    return await datasource.getProfile();
  }

  @override
  Future<Either<Fail, String?>> isEmailExists(String email) async {
    return await datasource.isEmailExists(email);
  }

  @override
  Future<Either<Fail, Unit>> deleteAccount() async {
    return await datasource.deleteAccount();
  }
}
