import '../models/numerology_result.dart';
import '../models/user_data.dart';

class NumerologyService {
  static const Map<String, int> _letterValues = {
    'A': 1,
    'B': 2,
    'C': 3,
    'D': 4,
    'E': 5,
    'F': 6,
    'G': 7,
    'H': 8,
    'I': 9,
    'J': 1,
    'K': 2,
    'L': 3,
    'M': 4,
    'N': 5,
    'O': 6,
    'P': 7,
    'Q': 8,
    'R': 9,
    'S': 1,
    'T': 2,
    'U': 3,
    'V': 4,
    'W': 5,
    'X': 6,
    'Y': 7,
    'Z': 8,
  };

  static const Set<String> _vowels = {'A', 'E', 'I', 'O', 'U'};

  /// Calculate all numerology numbers for the given user input
  static Future<NumerologyResult> calculateNumerology(
    UserData userInput,
  ) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    final lifePathNumber = _calculateLifePathNumber(userInput.dateOfBirth);
    final birthdayNumber = _calculateBirthdayNumber(userInput.dateOfBirth);
    final expressionNumber = _calculateExpressionNumber(userInput.fullName);
    final soulUrgeNumber = _calculateSoulUrgeNumber(userInput.fullName);
    final personalityNumber = _calculatePersonalityNumber(userInput.fullName);

    return NumerologyResult(
      lifePathNumber: lifePathNumber,
      birthdayNumber: birthdayNumber,
      expressionNumber: expressionNumber,
      soulUrgeNumber: soulUrgeNumber,
      personalityNumber: personalityNumber,
      fullName: userInput.fullName,
      dateOfBirth: userInput.dateOfBirth,
      calculatedAt: DateTime.now(),
    );
  }

  /// Calculate Life Path Number from date of birth
  static int _calculateLifePathNumber(DateTime dateOfBirth) {
    int day = dateOfBirth.day;
    int month = dateOfBirth.month;
    int year = dateOfBirth.year;

    // Reduce each component to a single digit
    day = _reduceToSingleDigit(day);
    month = _reduceToSingleDigit(month);
    year = _reduceToSingleDigit(year);

    // Add them together and reduce again
    int total = day + month + year;
    return _reduceToSingleDigit(total);
  }

  /// Calculate Birthday Number (day of birth reduced to single digit)
  static int _calculateBirthdayNumber(DateTime dateOfBirth) {
    return _reduceToSingleDigit(dateOfBirth.day);
  }

  /// Calculate Expression Number from full name
  static int _calculateExpressionNumber(String fullName) {
    int total = 0;
    String cleanName = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

    for (int i = 0; i < cleanName.length; i++) {
      String letter = cleanName[i];
      total += _letterValues[letter] ?? 0;
    }

    return _reduceToSingleDigit(total);
  }

  /// Calculate Soul Urge Number from vowels in full name
  static int _calculateSoulUrgeNumber(String fullName) {
    int total = 0;
    String cleanName = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

    for (int i = 0; i < cleanName.length; i++) {
      String letter = cleanName[i];
      if (_vowels.contains(letter)) {
        total += _letterValues[letter] ?? 0;
      }
    }

    return _reduceToSingleDigit(total);
  }

  /// Calculate Personality Number from consonants in full name
  static int _calculatePersonalityNumber(String fullName) {
    int total = 0;
    String cleanName = fullName.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');

    for (int i = 0; i < cleanName.length; i++) {
      String letter = cleanName[i];
      if (!_vowels.contains(letter)) {
        total += _letterValues[letter] ?? 0;
      }
    }

    return _reduceToSingleDigit(total);
  }

  /// Reduce a number to a single digit (1-9)
  /// Master numbers 11, 22, 33 are preserved in some traditions, but we'll reduce for simplicity
  static int _reduceToSingleDigit(int number) {
    while (number > 9) {
      int sum = 0;
      while (number > 0) {
        sum += number % 10;
        number ~/= 10;
      }
      number = sum;
    }
    return number == 0 ? 9 : number; // Ensure we never return 0
  }

  /// Get detailed description for a specific number and type
  static String getDetailedDescription(NumerologyType type, int number) {
    final baseDescription = type.description;
    final numberMeaning = _getNumberMeaning(number);

    return '$baseDescription\n\nNumber $number: $numberMeaning';
  }

  /// Get meaning for a specific number (1-9)
  static String _getNumberMeaning(int number) {
    switch (number) {
      case 1:
        return 'Leadership, independence, and pioneering spirit. You are a natural leader with strong willpower and determination.';
      case 2:
        return 'Cooperation, diplomacy, and sensitivity. You work well with others and have a natural ability to mediate and bring harmony.';
      case 3:
        return 'Creativity, communication, and self-expression. You are artistic, optimistic, and have a gift for inspiring others.';
      case 4:
        return 'Stability, hard work, and practicality. You are reliable, organized, and excel at building solid foundations.';
      case 5:
        return 'Freedom, adventure, and versatility. You crave variety and change, and have a natural curiosity about the world.';
      case 6:
        return 'Nurturing, responsibility, and service. You are caring, protective, and have a strong sense of duty to family and community.';
      case 7:
        return 'Spirituality, introspection, and analysis. You are a deep thinker who seeks truth and understanding through study and contemplation.';
      case 8:
        return 'Material success, ambition, and authority. You have strong business acumen and the ability to achieve material wealth and recognition.';
      case 9:
        return 'Humanitarianism, compassion, and universal love. You are generous, idealistic, and driven to serve the greater good.';
      default:
        return 'A unique number with special significance in your numerological profile.';
    }
  }
}
