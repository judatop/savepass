import 'package:dartz/dartz.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';

abstract class CardRepository {
  Future<Either<Fail, Unit>> insertCard(CardModel model);
  Future<Either<Fail, List<DashboardCardModel>>> getCards();
  Future<Either<Fail, String>> getCard(String cardId);
  Future<Either<Fail, CardModel>> getCardModel(String cardId);
  Future<Either<Fail, Unit>> editCard(CardModel model, String vaultId);
  Future<Either<Fail, Unit>> deleteCard(String cardId, String vaultId);
  Future<Either<Fail, String>> getCardValue(int index, String vaultId);
}
