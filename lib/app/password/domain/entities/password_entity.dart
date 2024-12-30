class PasswordEntity {
  final String? id;
  final String? passImg;
  final String? passName;
  final String passUser;
  final String passPassword;
  final String? passDesc;
  final String? passDomain;

  const PasswordEntity({
    this.id,
    this.passImg,
    this.passName,
    required this.passUser,
    required this.passPassword,
    this.passDesc,
    this.passDomain,
  });
}
