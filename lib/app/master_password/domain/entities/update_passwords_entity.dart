class UpdatePasswordsEntity {
  final String id;
  final String password;
  final String vaultId;

  const UpdatePasswordsEntity({
    required this.id,
    required this.password,
    required this.vaultId,
  });
}
