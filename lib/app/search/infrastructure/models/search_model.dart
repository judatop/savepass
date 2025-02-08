import 'package:equatable/equatable.dart';
import 'package:savepass/app/search/domain/entities/search_entity.dart';

class SearchModel extends SearchEntity with EquatableMixin {
  SearchModel({
    required super.id,
    required super.title,
    required super.subtitle,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
      ];
}
