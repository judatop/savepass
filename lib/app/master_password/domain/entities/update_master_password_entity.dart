class UpdateMasterPasswordEntity {
  final String oldPassword;
  final String newPassword;
  final String nameNewPassword;
  final String deviceIdParam;
  final String salt;

  const UpdateMasterPasswordEntity({
    required this.oldPassword,
    required this.newPassword,
    required this.nameNewPassword,
    required this.deviceIdParam,
    required this.salt,
  });
}
