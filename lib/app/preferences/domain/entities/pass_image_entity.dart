class PassImageEntity {
  final String id;
  final String key;
  final String value;
  final String? url;

  const PassImageEntity({
    required this.id,
    required this.key,
    required this.value,
    this.url,
  });
}
