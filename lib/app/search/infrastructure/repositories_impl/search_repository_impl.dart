import 'package:dartz/dartz.dart';
import 'package:savepass/app/search/domain/datasources/search_datasource.dart';
import 'package:savepass/app/search/domain/repositories/search_repository.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource datasource;

  SearchRepositoryImpl({required this.datasource});

  @override
  Future<Either<Fail, List<SearchModel>>> search(String search) async {
    return await datasource.search(search);
  }
}
