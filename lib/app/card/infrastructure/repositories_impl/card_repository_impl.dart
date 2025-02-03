import 'package:dartz/dartz.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';

class CardRepositoryImpl implements CardRepository {
  final CardDatasource datasource;

  CardRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, Unit>> deleteCard(String cardId, String vaultId) async {
    return await datasource.deleteCard(cardId, vaultId);
  }

  @override
  Future<Either<Fail, Unit>> editCard(CardModel model, String vaultId) async {
    return await datasource.editCard(model, vaultId);
  }

  @override
  Future<Either<Fail, String>> getCard(String cardId) async {
    return await datasource.getCard(cardId);
  }

  @override
  Future<Either<Fail, CardModel>> getCardModel(String cardId) async {
    return await datasource.getCardModel(cardId);
  }

  @override
  Future<Either<Fail, List<DashboardCardModel>>> getCards() async {
    return await datasource.getCards();
  }

  @override
  Future<Either<Fail, Unit>> insertCard(CardModel model) async {
    return await datasource.insertCard(model);
  }
  
  @override
  Future<Either<Fail, String>> getCardValue(int index, String vaultId) async {
    return await datasource.getCardValue(index, vaultId);
  }
}
