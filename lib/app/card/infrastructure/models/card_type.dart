enum CardType {
  visa,
  masterCard,
  americanExpress,
  discover,
  dinersClub,
  unknown
}

extension CardTypeExtension on CardType {
  String get stringValue {
    switch (this) {
      case CardType.visa:
        return 'Visa';
      case CardType.masterCard:
        return 'Master Card';
      case CardType.americanExpress:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
      case CardType.dinersClub:
        return 'Diners Club';
      case CardType.unknown:
        return 'Unknown Card';
    }
  }
}
