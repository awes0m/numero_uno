import 'numerology_result.dart';

// Enum for all numerology cards displayed in the UI.
// Note: We are not using a Hive adapter for this enum at the moment.
// If persistence of this enum is needed, add a TypeAdapter and register it.

enum NumerologyType {
  lifePathNumber,
  birthdayNumber,
  expressionNumber,
  soulUrgeNumber,
  personalityNumber,
  driverNumber,
  destinyNumber,
  firstNameNumber,
  fullNameNumber,
}

extension NumerologyTypeX on NumerologyType {
  String get displayName {
    switch (this) {
      case NumerologyType.lifePathNumber:
        return 'Life Path Number';
      case NumerologyType.birthdayNumber:
        return 'Birthday Number';
      case NumerologyType.expressionNumber:
        return 'Expression Number';
      case NumerologyType.soulUrgeNumber:
        return 'Soul Urge Number';
      case NumerologyType.personalityNumber:
        return 'Personality Number';
      case NumerologyType.driverNumber:
        return 'Driver Number';
      case NumerologyType.destinyNumber:
        return 'Destiny Number';
      case NumerologyType.firstNameNumber:
        return 'First Name Number';
      case NumerologyType.fullNameNumber:
        return 'Full Name Number';
    }
  }

  String get description {
    switch (this) {
      case NumerologyType.lifePathNumber:
        return 'Your life\'s purpose and journey';
      case NumerologyType.birthdayNumber:
        return 'Your natural talents and gifts';
      case NumerologyType.expressionNumber:
        return 'Your life\'s goal and mission';
      case NumerologyType.soulUrgeNumber:
        return 'Your inner desires and motivation';
      case NumerologyType.personalityNumber:
        return 'How others perceive you';
      case NumerologyType.driverNumber:
        return 'Your basic nature and drive';
      case NumerologyType.destinyNumber:
        return 'Your ultimate destiny';
      case NumerologyType.firstNameNumber:
        return 'Your social persona';
      case NumerologyType.fullNameNumber:
        return 'Your full identity';
    }
  }

  int getValue(NumerologyResult result) {
    switch (this) {
      case NumerologyType.lifePathNumber:
        return result.lifePathNumber;
      case NumerologyType.birthdayNumber:
        return result.birthdayNumber;
      case NumerologyType.expressionNumber:
        return result.expressionNumber;
      case NumerologyType.soulUrgeNumber:
        return result.soulUrgeNumber;
      case NumerologyType.personalityNumber:
        return result.personalityNumber;
      case NumerologyType.driverNumber:
        return result.driverNumber;
      case NumerologyType.destinyNumber:
        return result.destinyNumber;
      case NumerologyType.firstNameNumber:
        return result.firstNameNumber;
      case NumerologyType.fullNameNumber:
        return result.fullNameNumber;
    }
  }
}
