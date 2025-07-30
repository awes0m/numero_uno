import '../models/numerology_result.dart';
import '../models/user_data.dart';

class NumerologyService {
  static const Map<String, int> _letterValues = {
    'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9,
    'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'O': 6, 'P': 7, 'Q': 8, 'R': 9,
    'S': 1, 'T': 2, 'U': 3, 'V': 4, 'W': 5, 'X': 6, 'Y': 7, 'Z': 8,
  };

  static const Set<String> _vowels = {'A', 'E', 'I', 'O', 'U'};

  // Planetary associations for numbers
  static const Map<int, String> _planetaryRulers = {
    1: 'SUN (SURYA)',
    2: 'MOON (CHANDRA)',
    3: 'JUPITER (GURU)',
    4: 'RAHU (RAHU)',
    5: 'MERCURY (BUDH)',
    6: 'VENUS (SHUKRA)',
    7: 'KETU (KETU)',
    8: 'SATURN (SHANI)',
    9: 'MARS (MANGAL)',
  };

  // Friendship compatibility matrix
  static const Map<int, Map<String, List<int>>> _compatibility = {
    1: {'friendly': [1,2,3,5,6,9], 'enemy': [8], 'neutral': [4,7]},
    2: {'friendly': [1,2,3,5], 'enemy': [4,8,9], 'neutral': [6,7]},
    3: {'friendly': [1,3,5], 'enemy': [6], 'neutral': [2,4,7,8,9]},
    4: {'friendly': [1,5,6,7], 'enemy': [2,4,8,9], 'neutral': [3]},
    5: {'friendly': [1,2,3,5,6], 'enemy': [], 'neutral': [4,7,8,9]},
    6: {'friendly': [1,4,5,6], 'enemy': [3], 'neutral': [2,8,9]},
    7: {'friendly': [1,4,5,6], 'enemy': [], 'neutral': [2,3,7,8,9]},
    8: {'friendly': [3,5], 'enemy': [1,2,4,8], 'neutral': [6,7,9]},
    9: {'friendly': [1,5], 'enemy': [2,4], 'neutral': [3,6,7,8,9]},
  };

  // Driver/Destiny combination meanings
  static const Map<String, String> _combinationMeanings = {
    '1/1': 'Fortunes Favourite',
    '1/2': 'Best for Navy or water related work',
    '1/3': 'Best for occult',
    '1/4': 'Politics',
    '1/5': 'Banking and Finance',
    '1/6': 'Luxury Glamour',
    '1/7': 'Occult / Education',
    '1/8': 'Struggle / Marriage issues / Police /Politics',
    '1/9': 'Super Successful',
    '2/1': 'Successful',
    '2/2': 'Water related work',
    '2/3': 'Occult/ Education',
    '2/4': 'Struggle / Depression',
    '2/5': 'Best for Real Estate, banking, finance',
    '2/6': 'Sweets',
    '2/7': 'Teaching / Occult',
    '2/8': 'Struggle/health issue /Healer',
    '2/9': 'Marriage Problem',
    '3/1': 'Occult / Education',
    '3/2': 'Water Related Work',
    '3/3': 'Education / Occult',
    '3/4': 'Education / Doctor / Sales / Marketing',
    '3/5': 'Excellent in communication',
    '3/6': 'Struggle / Health / Marriage issues /Healer / Doctor/ Admin',
    '3/7': 'Education / Occult',
    '3/8': 'Lawyer / Printing / Sales',
    '3/9': 'Admin',
    '4/1': 'Politics',
    '4/2': 'Depression / Struggle',
    '4/3': 'Sales / Marketing / Occult / Education',
    '4/4': 'Best for Law / Struggle',
    '4/5': 'Banking / Event Management',
    '4/6': 'Media / Luxury / Glamour',
    '4/7': 'Successful / Occult Best',
    '4/8': 'Struggle / Best for Law',
    '4/9': 'Struggle / Health issues',
    '5/1': 'Successful Finance / Loan/Property',
    '5/2': 'Real Estate',
    '5/3': 'Communication / Occult',
    '5/4': 'Overall Successful',
    '5/5': 'Very successful',
    '5/6': 'Very Successful',
    '5/7': 'Occult and banking',
    '5/8': 'Property',
    '5/9': 'Successful Sales/Marketing',
    '6/1': 'Super successful in Media / Luxury / Glamour',
    '6/2': 'Sweet Shop',
    '6/3': 'Health / Marriage issues',
    '6/4': 'Successful / Media',
    '6/5': 'Super Successful',
    '6/6': 'Very Successful Media / Films/ Tours',
    '6/7': 'Successful / Sport/ Romantic',
    '6/8': 'Best for law',
    '6/9': 'Successful / Controversies',
    '7/1': 'Best in occult',
    '7/2': 'Disappointment / Marriage issues Occult/Intuition',
    '7/3': 'Teaching',
    '7/4': 'Successful',
    '7/5': 'Occult',
    '7/6': 'Sports',
    '7/7': 'Occult healing/occult',
    '7/8': 'Occult healing/occult',
    '7/9': 'Teaching Occult',
    '8/1': 'Marriage Problem',
    '8/2': 'Health Issue',
    '8/3': 'Struggle but good in Law/ Printing',
    '8/4': 'Sales/Marketing - Struggle',
    '8/5': 'Real Estate',
    '8/6': 'Best for law',
    '8/7': 'Occult',
    '8/8': 'sports',
    '8/9': 'Army',
    '9/1': 'Successful',
    '9/2': 'Struggle / Marriage issues',
    '9/3': 'Occult / Healing',
    '9/4': 'Struggle / Health Issues',
    '9/5': 'Successful',
    '9/6': 'Controversies',
    '9/7': 'Occult / Teaching',
    '9/8': 'Army / Police',
    '9/9': 'Marriage Problem',
  };

  /// Calculate all numerology numbers for the given user input
  static Future<NumerologyResult> calculateNumerology(
    UserData userInput,
  ) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    // Basic calculations
    final lifePathNumber = _calculateLifePathNumber(userInput.dateOfBirth);
    final birthdayNumber = _calculateBirthdayNumber(userInput.dateOfBirth);
    final expressionNumber = _calculateExpressionNumber(userInput.fullName);
    final soulUrgeNumber = _calculateSoulUrgeNumber(userInput.fullName);
    final personalityNumber = _calculatePersonalityNumber(userInput.fullName);

    // Enhanced calculations based on textbook
    final driverNumber = _calculateDriverNumber(userInput.dateOfBirth);
    final destinyNumber = _calculateDestinyNumber(userInput.dateOfBirth);
    final loshuGrid = _generateLoshuGrid(userInput.dateOfBirth);
    final missingNumbers = _findMissingNumbers(loshuGrid);
    final magicalNumbers = _findMagicalNumbers(loshuGrid);
    
    // Name calculations
    final firstNameNumber = _calculateFirstNameNumber(userInput.fullName);
    final fullNameNumber = _calculateFullNameNumber(userInput.fullName);
    
    // Personal timing calculations
    final currentDate = DateTime.now();
    final personalYear = _calculatePersonalYear(userInput.dateOfBirth, currentDate.year);
    final personalMonth = _calculatePersonalMonth(userInput.dateOfBirth, currentDate.year, currentDate.month);
    final personalDay = _calculatePersonalDay(userInput.dateOfBirth, currentDate);

    // Compatibility analysis
    final nameCompatibility = _analyzeNameCompatibility(driverNumber, destinyNumber, firstNameNumber, fullNameNumber);
    final driverDestinyMeaning = _getDDCombinationMeaning(driverNumber, destinyNumber);

    return NumerologyResult(
      // Original properties
      lifePathNumber: lifePathNumber,
      birthdayNumber: birthdayNumber,
      expressionNumber: expressionNumber,
      soulUrgeNumber: soulUrgeNumber,
      personalityNumber: personalityNumber,
      fullName: userInput.fullName,
      dateOfBirth: userInput.dateOfBirth,
      calculatedAt: DateTime.now(),
      
      // Enhanced properties
      driverNumber: driverNumber,
      destinyNumber: destinyNumber,
      loshuGrid: loshuGrid,
      missingNumbers: missingNumbers,
      magicalNumbers: magicalNumbers,
      firstNameNumber: firstNameNumber,
      fullNameNumber: fullNameNumber,
      personalYear: personalYear,
      personalMonth: personalMonth,
      personalDay: personalDay,
      nameCompatibility: nameCompatibility,
      driverDestinyMeaning: driverDestinyMeaning,
      planetaryRuler: _planetaryRulers[driverNumber] ?? 'Unknown',
    );
  }

  /// Calculate Driver/Basic Number (Mulank) - Day of birth reduced to single digit
  static int _calculateDriverNumber(DateTime dateOfBirth) {
    return _reduceToSingleDigit(dateOfBirth.day);
  }

  /// Calculate Destiny Number (Bhagyank) - Full date reduced to single digit
  static int _calculateDestinyNumber(DateTime dateOfBirth) {
    int day = dateOfBirth.day;
    int month = dateOfBirth.month;
    int year = dateOfBirth.year;
    
    // Add all digits in the full date
    String dateString = '$day$month$year';
    int total = 0;
    for (int i = 0; i < dateString.length; i++) {
      total += int.parse(dateString[i]);
    }
    
    return _reduceToSingleDigit(total);
  }

  /// Generate Loshu Grid (3x3 grid showing number frequencies)
  static Map<int, int> _generateLoshuGrid(DateTime dateOfBirth) {
    Map<int, int> grid = {};
    
    // Initialize grid with zeros
    for (int i = 1; i <= 9; i++) {
      grid[i] = 0;
    }
    
    // Count occurrences of each digit in the full date
    String dateString = '${dateOfBirth.day}${dateOfBirth.month}${dateOfBirth.year}';
    for (int i = 0; i < dateString.length; i++) {
      int digit = int.parse(dateString[i]);
      if (digit > 0 && digit <= 9) {
        grid[digit] = (grid[digit] ?? 0) + 1;
      }
    }
    
    // Add driver and destiny numbers
    int driver = _calculateDriverNumber(dateOfBirth);
    int destiny = _calculateDestinyNumber(dateOfBirth);
    
    // Don't double count if driver is same as day of birth
    if (dateOfBirth.day > 9 || driver != dateOfBirth.day) {
      grid[driver] = (grid[driver] ?? 0) + 1;
    }
    grid[destiny] = (grid[destiny] ?? 0) + 1;
    
    return grid;
  }

  /// Find missing numbers in Loshu Grid
  static List<int> _findMissingNumbers(Map<int, int> loshuGrid) {
    List<int> missing = [];
    for (int i = 1; i <= 9; i++) {
      if ((loshuGrid[i] ?? 0) == 0) {
        missing.add(i);
      }
    }
    return missing;
  }

  /// Find magical numbers (present numbers) in Loshu Grid
  static List<int> _findMagicalNumbers(Map<int, int> loshuGrid) {
    List<int> magical = [];
    for (int i = 1; i <= 9; i++) {
      if ((loshuGrid[i] ?? 0) > 0) {
        magical.add(i);
      }
    }
    return magical;
  }

  /// Calculate first name number
  static int _calculateFirstNameNumber(String fullName) {
    String firstName = fullName.trim().split(' ')[0];
    return _calculateNameValue(firstName);
  }

  /// Calculate full name number
  static int _calculateFullNameNumber(String fullName) {
    return _calculateNameValue(fullName);
  }

  /// Helper method to calculate name value
  static int _calculateNameValue(String name) {
    int total = 0;
    String cleanName = name.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    
    for (int i = 0; i < cleanName.length; i++) {
      String letter = cleanName[i];
      total += _letterValues[letter] ?? 0;
    }
    
    return _reduceToSingleDigit(total);
  }

  /// Calculate Personal Year
  static int _calculatePersonalYear(DateTime dateOfBirth, int currentYear) {
    int day = dateOfBirth.day;
    int month = dateOfBirth.month;
    
    String dateString = '$day$month$currentYear';
    int total = 0;
    for (int i = 0; i < dateString.length; i++) {
      total += int.parse(dateString[i]);
    }
    
    return _reduceToSingleDigit(total);
  }

  /// Calculate Personal Month
  static int _calculatePersonalMonth(DateTime dateOfBirth, int currentYear, int currentMonth) {
    int personalYear = _calculatePersonalYear(dateOfBirth, currentYear);
    return _reduceToSingleDigit(personalYear + currentMonth);
  }

  /// Calculate Personal Day
  static int _calculatePersonalDay(DateTime dateOfBirth, DateTime currentDate) {
    int personalYear = _calculatePersonalYear(dateOfBirth, currentDate.year);
    int personalMonth = _calculatePersonalMonth(dateOfBirth, currentDate.year, currentDate.month);
    
    String currentDateString = '${currentDate.day}${currentDate.month}${currentDate.year}';
    int currentDateSum = 0;
    for (int i = 0; i < currentDateString.length; i++) {
      currentDateSum += int.parse(currentDateString[i]);
    }
    
    int total = personalYear + personalMonth + currentDateSum;
    return _reduceToSingleDigit(total);
  }

  /// Analyze name compatibility with driver and destiny numbers
  static Map<String, dynamic> _analyzeNameCompatibility(
    int driverNumber, 
    int destinyNumber, 
    int firstNameNumber, 
    int fullNameNumber
  ) {
    return {
      'firstNameWithDriver': _getCompatibilityType(firstNameNumber, driverNumber),
      'firstNameWithDestiny': _getCompatibilityType(firstNameNumber, destinyNumber),
      'fullNameWithDriver': _getCompatibilityType(fullNameNumber, driverNumber),
      'fullNameWithDestiny': _getCompatibilityType(fullNameNumber, destinyNumber),
      'recommendation': _getNameRecommendation(driverNumber, destinyNumber, firstNameNumber, fullNameNumber),
    };
  }

  /// Get compatibility type between two numbers
  static String _getCompatibilityType(int number1, int number2) {
    Map<String, List<int>>? compatibility = _compatibility[number1];
    if (compatibility == null) return 'Unknown';
    
    if (compatibility['friendly']?.contains(number2) == true) {
      return 'Friendly';
    } else if (compatibility['enemy']?.contains(number2) == true) {
      return 'Enemy';
    } else if (compatibility['neutral']?.contains(number2) == true) {
      return 'Neutral';
    }
    
    return 'Unknown';
  }

  /// Get name recommendation based on compatibility
  static String _getNameRecommendation(
    int driverNumber, 
    int destinyNumber, 
    int firstNameNumber, 
    int fullNameNumber
  ) {
    bool firstNameGood = _getCompatibilityType(firstNameNumber, driverNumber) != 'Enemy' &&
                        _getCompatibilityType(firstNameNumber, destinyNumber) != 'Enemy';
    bool fullNameGood = _getCompatibilityType(fullNameNumber, driverNumber) != 'Enemy' &&
                       _getCompatibilityType(fullNameNumber, destinyNumber) != 'Enemy';
    
    if (firstNameGood && fullNameGood) {
      return 'Excellent! Your name is well balanced with your numbers.';
    } else if (!firstNameGood && !fullNameGood) {
      return 'Consider name balancing. Both first and full name have challenging aspects.';
    } else if (!firstNameGood) {
      return 'Consider adjusting your first name for better compatibility.';
    } else {
      return 'Consider minor adjustments to your full name for optimal balance.';
    }
  }

  /// Get Driver/Destiny combination meaning
  static String _getDDCombinationMeaning(int driverNumber, int destinyNumber) {
    String key = '$driverNumber/$destinyNumber';
    return _combinationMeanings[key] ?? 'Unique combination with special significance.';
  }

  /// Calculate numerology for mobile, bank account, or vehicle numbers
  static int calculateNumberNumerology(String numberString) {
    int total = 0;
    String cleanNumber = numberString.replaceAll(RegExp(r'[^0-9]'), '');
    
    for (int i = 0; i < cleanNumber.length; i++) {
      total += int.parse(cleanNumber[i]);
    }
    
    return _reduceToSingleDigit(total);
  }

  /// Calculate Life Path Number from date of birth (original method)
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
    return _calculateNameValue(fullName);
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
    final planetaryRuler = _planetaryRulers[number] ?? 'Unknown';

    return '$baseDescription\n\nNumber $number (Ruled by $planetaryRuler): $numberMeaning';
  }

  /// Get meaning for a specific number (1-9) with enhanced descriptions
  static String _getNumberMeaning(int number) {
    switch (number) {
      case 1:
        return 'Leadership, independence, and pioneering spirit. You are a natural leader with strong willpower and determination. Ruled by the Sun, you have the qualities of a king - communication skills, authority, and the ability to inspire others.';
      case 2:
        return 'Cooperation, diplomacy, and sensitivity. You work well with others and have a natural ability to mediate and bring harmony. Ruled by the Moon, you possess queen-like qualities - intuition, sensitivity, and emotional intelligence.';
      case 3:
        return 'Creativity, communication, and self-expression. You are artistic, optimistic, and have a gift for inspiring others. Ruled by Jupiter, you are like a wise councillor with creative imagination and the ability to guide others.';
      case 4:
        return 'Stability, hard work, and practicality. You are reliable, organized, and excel at building solid foundations. Ruled by Rahu, you have Robin Hood-like qualities - discipline, organizational skills, and a strong sense of justice.';
      case 5:
        return 'Freedom, adventure, and versatility. You crave variety and change, and have a natural curiosity about the world. Ruled by Mercury, you are like a prince with excellent communication skills and the ability to balance different aspects of life.';
      case 6:
        return 'Nurturing, responsibility, and service. You are caring, protective, and have a strong sense of duty to family and community. Ruled by Venus, you are a councillor focused on home, family, and creating beauty in the world.';
      case 7:
        return 'Spirituality, introspection, and analysis. You are a deep thinker who seeks truth and understanding through study and contemplation. Ruled by Ketu, you may face disappointments but have strong spiritual inclinations and mystical abilities.';
      case 8:
        return 'Material success, ambition, and authority. You have strong business acumen and the ability to achieve material wealth and recognition. Ruled by Saturn, you are like a judge with excellent money and finance management skills, though you may face struggles.';
      case 9:
        return 'Humanitarianism, compassion, and universal love. You are generous, idealistic, and driven to serve the greater good. Ruled by Mars, you are an advisor with humanitarian instincts and strong social consciousness.';
      default:
        return 'A unique number with special significance in your numerological profile.';
    }
  }

  /// Get favorable years/months/days
  static List<int> getFavorableNumbers() {
    return [1, 3, 5, 6]; // Generally considered good numbers
  }

  /// Get Yantra recommendations for missing numbers
  static List<String> getYantraRecommendations(List<int> missingNumbers) {
    List<String> recommendations = [];
    
    for (int number in missingNumbers) {
      switch (number) {
        case 1:
          recommendations.add('Surya Yantra - For leadership and confidence');
          break;
        case 2:
          recommendations.add('Chandra Yantra - For emotional balance and intuition');
          break;
        case 3:
          recommendations.add('Guru Yantra - For wisdom and creativity');
          break;
        case 4:
          recommendations.add('Rahu Yantra - For discipline and organization');
          break;
        case 5:
          recommendations.add('Budh Yantra - For communication and balance');
          break;
        case 6:
          recommendations.add('Shukra Yantra - For love and family harmony');
          break;
        case 7:
          recommendations.add('Ketu Yantra - For spiritual growth and intuition');
          break;
        case 8:
          recommendations.add('Shani Yantra - For financial stability and discipline');
          break;
        case 9:
          recommendations.add('Mangal Yantra - For energy and humanitarian service');
          break;
      }
    }
    
    // Add general recommendations
    recommendations.addAll([
      'Vyapar Vridhi Yantra - For business growth',
      'Shiksha Yantra - For education and learning',
      'Nazar Yantra - For protection from negative energies'
    ]);
    
    return recommendations;
  }

  /// Check if current period is favorable
  static bool isFavorablePeriod(int personalYear, int personalMonth, int personalDay) {
    List<int> favorable = [1, 3, 5, 6, 7]; // 7 is good for occult work
    
    return favorable.contains(personalYear) || 
           favorable.contains(personalMonth) || 
           favorable.contains(personalDay);
  }

  /// Get business name suggestions based on owner's numbers
  static List<String> getBusinessNameSuggestions(int driverNumber, int destinyNumber) {
    List<int> compatibleNumbers = [];
    
    // Get friendly numbers for both driver and destiny
    compatibleNumbers.addAll(_compatibility[driverNumber]?['friendly'] ?? []);
    compatibleNumbers.addAll(_compatibility[destinyNumber]?['friendly'] ?? []);
    
    // Remove duplicates
    compatibleNumbers = compatibleNumbers.toSet().toList();
    
    List<String> suggestions = [
      'Choose a business name that reduces to one of these numbers: ${compatibleNumbers.join(', ')}',
      'Avoid names that reduce to enemy numbers',
      'For partnerships, ensure the name is compatible with all partners\' driver and destiny numbers',
      'The business name should complement your personal name numbers'
    ];
    
    return suggestions;
  }
}