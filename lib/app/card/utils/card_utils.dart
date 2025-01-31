class CardUtils {
  static String formatCreditCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');

    return cardNumber.replaceAllMapped(
      RegExp(r'.{1,4}'),
      (match) => '${match.group(0)} ',
    );
  }
}
