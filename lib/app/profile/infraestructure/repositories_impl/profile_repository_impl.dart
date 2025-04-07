import 'package:dartz/dartz.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/app/profile/domain/repositories/profile_repository.dart';
import 'package:savepass/app/profile/infraestructure/models/insert_master_password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

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
  Future<Either<Fail, SavePassResponseModel>> insertMasterPassword({
    required InsertMasterPasswordModel model,
  }) async {
    return await datasource.insertMasterPassword(model: model);
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> checkIfHasMasterPassword() async {
    return await datasource.checkIfHasMasterPassword();
  }

  @override
  Future<Either<Fail, ProfileEntity>> getProfile() async {
    return await datasource.getProfile();
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> isEmailExists({
    required String email,
  }) async {
    return await datasource.isEmailExists(email: email);
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> deleteAccount() async {
    return await datasource.deleteAccount();
  }
  
  @override
  Future<Either<Fail, Unit>> deleteAvatar() async {
    return await datasource.deleteAvatar();
  }
}
