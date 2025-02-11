import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/app/card/infrastructure/models/dashboard_card_model.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabaseCardDatasource implements CardDatasource {
  final Logger log;

  SupabaseCardDatasource({required this.log});

  @override
  Future<Either<Fail, Unit>> deleteCard(String cardId, String vaultId) async {
    try {
      await supabase.rpc(
        DbUtils.deleteCardFunction,
        params: {
          'card_id_param': cardId,
          'vault_id_param': vaultId,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('deleteCard: $e');
      return Left(
        Fail('Error occurred while deleting your card'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> editCard(CardModel model, String vaultId) async {
    try {
      await supabase.rpc(
        DbUtils.editCardFunction,
        params: {
          'type_param': model.type,
          'card_param': model.card,
          'description_param': '',
          'card_id_param': model.id,
          'vault_id_param': vaultId,
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('editCard: $e');
      return Left(
        Fail('Error occurred while editting card'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getCard(String cardId) async {
    try {
      final response = await supabase.rpc(
        DbUtils.getCardFunction,
        params: {
          'secret_uuid': cardId,
        },
      );

      if (response == null) {
        return Left(Fail('Card not found'));
      }

      return Right(response as String);
    } catch (e) {
      log.e('getCard: $e');
      return Left(
        Fail('Error occurred while getting the card'),
      );
    }
  }

  @override
  Future<Either<Fail, CardModel>> getCardModel(String cardId) async {
    try {
      final response =
          await supabase.from(DbUtils.cardsTable).select().eq('id', cardId);

      CardModel card = CardModel.fromJson(response.first);

      return Right(card);
    } catch (e) {
      log.e('getCardModel: $e');
      return Left(
        Fail('Error occurred while getting your card model'),
      );
    }
  }

  @override
  Future<Either<Fail, List<DashboardCardModel>>> getCards() async {
    try {
      final response = await supabase.rpc(DbUtils.getCardsFunction);

      List<DashboardCardModel> cards = (response as List<dynamic>).map((e) {
        return DashboardCardModel.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Right(cards);
    } catch (e) {
      log.e('getCards: $e');
      return Left(
        Fail('Error occurred while gettings cards'),
      );
    }
  }

  @override
  Future<Either<Fail, Unit>> insertCard(CardModel model) async {
    try {
      await supabase.rpc(
        DbUtils.insertCardFunction,
        params: {
          'type': model.type,
          'card': model.card,
          'description': '',
        },
      );

      return const Right(unit);
    } catch (e) {
      log.e('insertCard: $e');
      return Left(
        Fail('Error occurred while inserting card'),
      );
    }
  }

  @override
  Future<Either<Fail, String>> getCardValue(int index, String vaultId) async {
    try {
      final response = await supabase.rpc(
        DbUtils.getCardValueFunction,
        params: {
          'index_val': index,
          'secret_uuid': vaultId,
        },
      );

      return Right(response as String);
    } catch (e) {
      log.e('getCardValue: $e');
      return Left(
        Fail('Error occurred while getting card value'),
      );
    }
  }
  
  @override
  Future<Either<Fail, List<DashboardCardModel>>> searchCards(String search) async {
     try {
      final response = await supabase.rpc(
        DbUtils.searchCardFunction,
        params: {
          'search': search,
        },
      );

      if (response == null) {
        return Left(Fail('Error in search'));
      }

      List<DashboardCardModel> items = (response as List<dynamic>).map((e) {
        return DashboardCardModel.fromJson(e as Map<String, dynamic>);
      }).toList();

      return Right(items);
    } catch (e) {
      log.e('search: $e');
      return Left(
        Fail('Error occurred while searching'),
      );
    }
  }
}
