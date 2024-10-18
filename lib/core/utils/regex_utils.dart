class RegexUtils {
  static final numbersAndLettersWithSpace = RegExp(r'[0-9a-zA-Z\s]');
  static final password = RegExp(r'[0-9a-zA-Z!@#\$%^&*(),.?":{}|<>\s]');
  static final regexEmail = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
}
