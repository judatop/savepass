class RegexUtils {
  static final numbersAndLettersWithSpace = RegExp(r'[0-9a-zA-Z\s]');
  static final numbers = RegExp(r'[0-9]');
  static final password = RegExp(r'[0-9a-zA-Z!@#\$%^&*(),.?":{}|<>\s]');
  static final regexEmail = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final regexDomain = RegExp(
    r'^[a-zA-Z0-9.-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final lettersWithSpaceCapitalCase = RegExp(r'^[A-Z\s]+$');
  static final lettersWithSpace = RegExp(r'^[a-zA-Z\s]+$');
}
