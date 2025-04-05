import 'package:dartz/dartz.dart';
import 'package:savepass/app/master_password/infrastructure/models/update_master_password_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class MasterPasswordRepository {
  Future<Either<Fail, SavePassResponseModel>> updateMasterPassword({
    required UpdateMasterPasswordModel model,
  });
}
