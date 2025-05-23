import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:savepass/app/card/domain/datasources/card_datasource.dart';
import 'package:savepass/app/card/infrastructure/models/card_model.dart';
import 'package:savepass/core/api/savepass_response_model.dart';
import 'package:savepass/core/api/supabase_middleware.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/core/utils/snackbar_utils.dart';

class SupabaseCardDatasource implements CardDatasource {
  final Logger log;
  final SupabaseMiddleware middleware;

  SupabaseCardDatasource({
    required this.log,
    required this.middleware,
  });

  @override
  Future<Either<Fail, SavePassResponseModel>> deleteCard({
    required String cardId,
    required String vaultId,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.deleteCardFunction,
        params: {
          'card_id_param': cardId,
          'vault_id_param': vaultId,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('deleteCard: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> editCard({
    required CardModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.editCardFunction,
        params: model.toEditJson(),
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('editCard: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getCards() async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.getCardsFunction,
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('getCards: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> insertCard({
    required CardModel model,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.insertCardFunction,
        params: model.toInsertJson(),
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('insertCard: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> searchCards({
    required String search,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.searchCardFunction,
        params: {
          'search_param': search,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('searchCards: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }

  @override
  Future<Either<Fail, SavePassResponseModel>> getCardById({
    required String cardId,
  }) async {
    try {
      final response = await middleware.doHttp(
        rpc: DbUtils.getCardByIdFunction,
        params: {
          'card_id_param': cardId,
        },
      );

      return Right(response);
    } catch (e, stackTrace) {
      log.severe('getCardById: $e', e, stackTrace);
      return Left(Fail(SnackBarErrors.generalErrorCode));
    }
  }
}
