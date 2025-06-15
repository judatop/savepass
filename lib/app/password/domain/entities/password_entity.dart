class PasswordEntity {
  final String? id;
  final String? typeImg;
  final String? name;
  final String password;
  final String? vaultId;
  final String? description;
  final String? domain;

  const PasswordEntity({
    this.id,
    this.typeImg,
    this.name,
    required this.password,
    this.vaultId,
    this.description,
    this.domain,
  });
}
