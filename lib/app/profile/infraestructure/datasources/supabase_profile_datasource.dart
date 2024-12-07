import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/profile/domain/datasources/profile_datasource.dart';
import 'package:savepass/app/profile/domain/entities/profile_entity.dart';
import 'package:savepass/app/profile/infraestructure/models/profile_model.dart';
import 'package:savepass/core/env/env.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';
import 'package:savepass/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseProfileDatasource implements ProfileDatasource {
  final Logger log;

  SupabaseProfileDatasource({required this.log});

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
    } catch (e) {
      log.e('uploadAvatar: $e');
      return Left(
        Fail('Error occurred while uploading avatar'),
      );
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
        userMetaData?['avatar_url'] = avatarUuid;
      }

      await supabase.auth.updateUser(
        UserAttributes(
          data: userMetaData,
        ),
      );

      return const Right(unit);
    } catch (e) {
      log.e('createProfile: $e');
      return Left(
        Fail('Error occurred while creating your profile'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> insertMasterPassword({
    required String masterPassword,
    required String name,
  }) async {
    try {
      await supabase.rpc(
        DbUtils.insertMasterPassword,
        params: {
          'secret': masterPassword,
          'name': name,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('insertMasterPassword: $e');
      return Left(
        Fail('Error occurred while inserting your master password'),
      );
    }
  }

  @override
  Future<Either<Fail, bool>> checkIfHasMasterPassword() async {
    try {
      final hasMasterPassword =
          await supabase.rpc(DbUtils.hasMasterPasswordFunction);

      return Right(hasMasterPassword as bool);
    } catch (e) {
      log.e('checkIfHasMasterPassword: $e');
      return Left(
        Fail('Error occurred while checking if you have master password'),
      );
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
    } catch (e) {
      log.e('getProfile: $e');
      return Left(
        Fail(SnackBarErrors.generalErrorCode),
      );
    }
  }

  @override
  Future<Either<Fail, String?>> isEmailExists(String email) async {
    try {
      final emailAlreadyExists = await supabase.rpc(
        DbUtils.isEmailExists,
        params: {
          'email_to_verify': email,
        },
      );

      if (emailAlreadyExists == null) {
        return const Right(null);
      }

      Map<String, dynamic> jsonMap = jsonDecode(emailAlreadyExists);

      return Right(jsonMap['provider'] as String?);
    } catch (e) {
      log.e('isEmailExists: $e');
      return Left(
        Fail('Error occurred while checking if email already exists'),
      );
    }
  }
}
