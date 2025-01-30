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
}
