import 'package:dartz/dartz.dart';
import 'package:savepass/app/search/infrastructure/models/search_model.dart';

abstract class SearchRepository {
  Future<Either<Fail, List<SearchModel>>> search(String search);
}
