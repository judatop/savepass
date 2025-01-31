class PassImageEntity {
  final String id;
  final String key;
  final String type;
  final String? domain;

  const PassImageEntity({
    required this.id,
    required this.key,
    required this.type,
    this.domain,
  });
}
