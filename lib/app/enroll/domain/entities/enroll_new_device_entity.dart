class EnrollNewDeviceEntity {
  final String deviceId;
  final String deviceName;
  final String type;
  final String deviceIdToDisable;

  const EnrollNewDeviceEntity({
    required this.deviceId,
    required this.deviceName,
    required this.type,
    required this.deviceIdToDisable,
  });
}
