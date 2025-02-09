import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:savepass/app/search/domain/datasources/search_datasource.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';
import 'package:savepass/core/utils/db_utils.dart';
import 'package:savepass/main.dart';

class SupabaseSearchDatasource implements SearchDatasource {
  final Logger log;

  SupabaseSearchDatasource({required this.log});

  @override
  Future<Either<Fail, List<SearchModel>>> search(String search) async {
    try {
      final response = await supabase.rpc(
        DbUtils.searchFunction,
        params: {
          'search': search,
        },
      );

      if (response == null) {
        return Left(Fail('Error in search'));
      }

      List<SearchModel> items = (response as List<dynamic>).map((e) {
        return SearchModel.fromJson(e as Map<String, dynamic>);
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
