class CardEntity {
  final String? id;
  final String? type;
  final String? typeId;
  final String? imgUrl;
  final String card;
  final String? vaultId;
  final String? description;

  const CardEntity({
    this.id,
    this.type,
    this.typeId,
    this.imgUrl,
    required this.card,
    this.vaultId,
    this.description,
  });
}
