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
  Future<Either<Fail, Unit>> createProfile({
    required String userId,
    String? displayName,
    String? avatarUuid,
  }) async {
    try {
      final profileUuid = const Uuid().v4();
      await supabase.from('profiles').insert({
        'id': profileUuid,
        'user_uuid': userId,
        'display_name': displayName,
        'avatar_uuid': avatarUuid,
        'active': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return const Right(unit);
    } catch (e) {
      log.e('createProfile: $e');
      return Left(
        Fail('Error occurred while creating your profile'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> updateMasterPasswordUuid({
    required String uuid,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final getProfileRes = await getProfile();

      if (getProfileRes.isLeft()) {
        // Doesn't have profile, so we need to create one

        final newProfileRes = await createProfile(userId: userId);
        if (newProfileRes.isLeft()) {
          return Left(
            Fail(SnackBarErrors.generalErrorCode),
          );
        }
      }

      await supabase.from(DbUtils.profilesTable).update({
        'master_password_uuid': uuid,
      }).eq('user_uuid', supabase.auth.currentUser!.id);

      return const Right(unit);
    } catch (e) {
      log.e('updateMasterPasswordUuid: $e');
      return Left(
        Fail('Error occurred while updating your master password'),
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
      final res = await supabase
          .from(DbUtils.profilesTable)
          .select('display_name, avatar_uuid, master_password_uuid');

      if (res.isEmpty) {
        return Left(
          Fail('Profile not found'),
        );
      }

      final profile = ProfileModel.fromJson(res[0]);

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
}
