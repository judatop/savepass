import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/web.dart';
import 'package:savepass/app/profile/presentation/blocs/profile_bloc.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabaseMiddleware {
  final Logger log;
  final omitRpcs = [
    DbUtils.hasMasterPasswordFunction,
    DbUtils.checkMasterPasswordFunction,
    DbUtils.deviceNameFunction,
    DbUtils.getUserSaltFunction,
    DbUtils.isEmailExistsFunction,
    DbUtils.insertMasterPassword,
  ];

  SupabaseMiddleware({required this.log});

  Future<SavePassResponseModel> doHttp({
    required String rpc,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (!omitRpcs.contains(rpc)) {
        final bloc = Modular.get<ProfileBloc>();
        final jwt = bloc.state.model.jwt;

        if (jwt == null) {
          log.w('JWT is null');
        }

        if (params == null) {
          params = {
            'jwt': jwt,
          };
        } else {
          params.addAll({
            'jwt': jwt,
          });
        }
      }

      final response = await supabase.rpc(
        rpc,
        params: params,
      );

      final json = jsonDecode(response);
      final model = SavePassResponseModel.fromJson(json);

      return model;
    } catch (e) {
      rethrow;
    }
  }
}
