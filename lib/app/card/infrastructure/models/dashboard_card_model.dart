import 'package:equatable/equatable.dart';

class DashboardCardModel with EquatableMixin {
  final String id;
  final String vaultId;
  final String type;
  final String url;
  final String cardNumber;
  final String cardHolderName;

  const DashboardCardModel({
    required this.id,
    required this.vaultId,
    required this.type,
    required this.url,
    required this.cardNumber,
    required this.cardHolderName,
  });

  factory DashboardCardModel.fromJson(Map<String, dynamic> json) {
    return DashboardCardModel(
      id: json['id'],
      vaultId: json['vault_id'],
      type: json['type'],
      url: json['url'],
      cardNumber: json['card_number'],
      cardHolderName: json['card_holdername'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        vaultId,
        type,
        url,
        cardNumber,
        cardHolderName,
      ];
}
