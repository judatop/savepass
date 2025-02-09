class SearchEntity {
  final String id;
  final String title;
  final String subtitle;
  final String? imgUrl;
  final String type;
  final String vaultId;

  const SearchEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imgUrl,
    required this.type,
    required this.vaultId,
  });
}
