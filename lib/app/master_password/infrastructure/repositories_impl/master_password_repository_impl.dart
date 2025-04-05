import 'package:dartz/dartz.dart';
import 'package:savepass/app/master_password/domain/datasources/master_password_datasource.dart';
import 'package:savepass/app/master_password/domain/repositories/master_password_repository.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_master_password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

class MasterPasswordRepositoryImpl implements MasterPasswordRepository {
  final MasterPasswordDatasource datasource;

  MasterPasswordRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, SavePassResponseModel>> updateMasterPassword({
    required UpdateMasterPasswordModel model,
  }) async {
    return await datasource.updateMasterPassword(model: model);
  }
}
