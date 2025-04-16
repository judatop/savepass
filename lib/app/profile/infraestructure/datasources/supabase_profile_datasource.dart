import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/app/profile/infraestructure/models/insert_master_password_model.dart';
import 'package:savepass/app/profile/infraestructure/models/profile_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseProfileDatasource implements ProfileDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseProfileDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, String>> uploadAvatar(String imgPath) async {
    try {
      final avatarFile = File(imgPath);
      final avatarUuid = const Uuid().v4();
      await supabase.storage.from(Env.supabaseBucket).upload(
            '${Env.supabaseBucketAvatarsFolder}/$avatarUuid',
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return Right(avatarUuid);
    } catch (e, stackTrace) {
      log.severe('uploadAvatar: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, Unit>> updateProfile({
    String? displayName,
    String? avatarUuid,
  }) async {
    try {
      final userMetaData = supabase.auth.currentUser!.userMetadata;

      if (displayName != null) {
        userMetaData?['full_name'] = displayName;
      }

      if (avatarUuid != null) {
        await deleteAvatar();
        userMetaData?['custom_avatar'] = avatarUuid;
      }

      await supabase.auth.updateUser(
        UserAttributes(
          data: userMetaData,
        ),
      );

      return const Right(unit);
    } catch (e, stackTrace) {
      log.severe('createProfile: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> insertMasterPassword({
    required InsertMasterPasswordModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.insertMasterPassword,
        params: model.toJson(),
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('insertMasterPassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> checkIfHasMasterPassword() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.hasMasterPasswordFunction,
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('checkIfHasMasterPassword: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, ProfileEntity>> getProfile() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null || user.userMetadata == null) {
        return Left(
          Fail('Profile not found'),
        );
      }

      final profile = ProfileModel.fromJson(user.userMetadata!);

      String? url;
      if (profile.avatar != null && !(profile.avatar!.startsWith('http'))) {
        url = await supabase.storage.from(Env.supabaseBucket).createSignedUrl(
              '${Env.supabaseBucketAvatarsFolder}/${profile.avatar}',
              3600,
            );
      } else {
        url = profile.avatar;
      }

      final finalProfile = profile.copyWith(avatar: url);

      return Right(finalProfile);
    } catch (e, stackTrace) {
      log.severe('getProfile: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> isEmailExists({
    required String email,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.isEmailExistsFunction,
        params: {
          'email_to_verify': email,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('isEmailExists: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> deleteAccount() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.deleteAccountFunction,
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('deleteAccount: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, Unit>> deleteAvatar() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null || user.userMetadata == null) {
        return Left(
          Fail('Profile not found'),
        );
      }

      final profile = ProfileModel.fromJson(user.userMetadata!);
      await supabase.storage.from(Env.supabaseBucket).remove(
        ['${Env.supabaseBucketAvatarsFolder}/${profile.avatar}'],
      );

      return const Right(unit);
    } catch (e, stackTrace) {
      log.severe('deleteAvatar: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
