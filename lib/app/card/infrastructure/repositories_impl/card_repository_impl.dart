import 'package:dartz/dartz.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';

class CardRepositoryImpl implements CardRepository {
  final CardDatasource datasource;

  CardRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, Unit>> deletePassword(String cardId, String vaultId) {
    // TODO: implement deletePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Fail, Unit>> editCard(CardModel model, String clearCard) {
    // TODO: implement editCard
    throw UnimplementedError();
  }

  @override
  Future<Either<Fail, String>> getCard(String cardId) {
    // TODO: implement getCard
    throw UnimplementedError();
  }

  @override
  Future<Either<Fail, CardModel>> getCardModel(String cardId) {
    // TODO: implement getCardModel
    throw UnimplementedError();
  }

  @override
  Future<Either<Fail, List<DashboardCardModel>>> getCards() async {
    return await datasource.getCards();
  }

  @override
  Future<Either<Fail, Unit>> insertCard(CardModel model) async {
    return await datasource.insertCard(model);
  }
}
