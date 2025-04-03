class InsertMasterPasswordEntity {
  final String secret;
  final String name;
  final String deviceId;
  final String deviceName;
  final String type;
  final String salt;

  const InsertMasterPasswordEntity({
    required this.secret,
    required this.name,
    required this.deviceId,
    required this.deviceName,
    required this.type,
    required this.salt,
  });
}
