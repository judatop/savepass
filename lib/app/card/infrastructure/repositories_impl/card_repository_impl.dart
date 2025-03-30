import 'package:dartz/dartz.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/domain/repositories/card_repository.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';

class CardRepositoryImpl implements CardRepository {
  final CardDatasource datasource;
  final SupabaseMiddleware middleware;

  CardRepositoryImpl({
    required this.datasource,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> deleteCard({
    required String cardId,
    required String vaultId,
  }) async {
    return await datasource.deleteCard(
      cardId: cardId,
      vaultId: vaultId,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> editCard({
    required CardModel model,
  }) async {
    return await datasource.editCard(
      model: model,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getCardById({
    required String cardId,
  }) async {
    return await datasource.getCardById(
      cardId: cardId,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getCards() async {
    return await datasource.getCards();
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> insertCard({
    required CardModel model,
  }) async {
    return await datasource.insertCard(
      model: model,
    );
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> searchCards({
    required String search,
  }) async {
    return await datasource.searchCards(
      search: search,
    );
  }
}
