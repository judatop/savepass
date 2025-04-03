import 'package:dartz/dartz.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';

abstract class CardRepository {
  Future<Either<Fail, SavePassResponseModel>> insertCard({
    required CardModel model,
  });

  Future<Either<Fail, SavePassResponseModel>> editCard({
    required CardModel model,
  });

  Future<Either<Fail, SavePassResponseModel>> deleteCard({
    required String cardId,
    required String vaultId,
  });

  Future<Either<Fail, SavePassResponseModel>> getCards();

  Future<Either<Fail, SavePassResponseModel>> getCardById({
    required String cardId,
  });

  Future<Either<Fail, SavePassResponseModel>> searchCards({
    required String search,
  });
}
