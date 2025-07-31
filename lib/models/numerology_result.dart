import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'numerology_result.g.dart';

@HiveType(typeId: 1)
class NumerologyResult extends Equatable {
  // Original properties
  @HiveField(0)
  final int lifePathNumber;
  
  @HiveField(1)
  final int birthdayNumber;
  
  @HiveField(2)
  final int expressionNumber;
  
  @HiveField(3)
  final int soulUrgeNumber;
  
  @HiveField(4)
  final int personalityNumber;
  
  @HiveField(5)
  final String fullName;
  
  @HiveField(6)
  final DateTime dateOfBirth;
  
  @HiveField(7)
  final DateTime calculatedAt;

  // Enhanced properties based on textbook
  @HiveField(8)
  final int driverNumber;           // Mulank - Day of birth reduced
  
  @HiveField(9)
  final int destinyNumber;          // Bhagyank - Full date reduced
  
  @HiveField(10)
  final Map<int, int> loshuGrid;    // 3x3 grid showing number frequencies
  
  @HiveField(11)
  final List<int> missingNumbers;   // Numbers absent in Loshu Grid
  
  @HiveField(12)
  final List<int> magicalNumbers;   // Numbers present in Loshu Grid
  
  @HiveField(13)
  final int firstNameNumber;        // First name numerology value
  
  @HiveField(14)
  final int fullNameNumber;         // Full name numerology value
  
  @HiveField(15)
  final int personalYear;           // Current personal year
  
  @HiveField(16)
  final int personalMonth;          // Current personal month
  
  @HiveField(17)
  final int personalDay;            // Current personal day
  
  @HiveField(18)
  final Map<String, dynamic> nameCompatibility; // Name compatibility analysis
  
  @HiveField(19)
  final String driverDestinyMeaning; // Meaning of driver/destiny combination
  
  @HiveField(20)
  final String planetaryRuler;      // Planetary ruler of driver number

  const NumerologyResult({
    // Original parameters
    required this.lifePathNumber,
    required this.birthdayNumber,
    required this.expressionNumber,
    required this.soulUrgeNumber,
    required this.personalityNumber,
    required this.fullName,
    required this.dateOfBirth,
    required this.calculatedAt,
    
    // Enhanced parameters
    required this.driverNumber,
    required this.destinyNumber,
    required this.loshuGrid,
    required this.missingNumbers,
    required this.magicalNumbers,
    required this.firstNameNumber,
    required this.fullNameNumber,
    required this.personalYear,
    required this.personalMonth,
    required this.personalDay,
    required this.nameCompatibility,
    required this.driverDestinyMeaning,
    required this.planetaryRuler,
  });

  @override
  List<Object> get props => [
        lifePathNumber,
        birthdayNumber,
        expressionNumber,
        soulUrgeNumber,
        personalityNumber,
        fullName,
        dateOfBirth,
        calculatedAt,
        driverNumber,
        destinyNumber,
        loshuGrid,
        missingNumbers,
        magicalNumbers,
        firstNameNumber,
        fullNameNumber,
        personalYear,
        personalMonth,
        personalDay,
        nameCompatibility,
        driverDestinyMeaning,
        planetaryRuler,
      ];

  @override
  String toString() {
    return 'NumerologyResult('
        'lifePathNumber: $lifePathNumber, '
        'birthdayNumber: $birthdayNumber, '
        'expressionNumber: $expressionNumber, '
        'soulUrgeNumber: $soulUrgeNumber, '
        'personalityNumber: $personalityNumber, '
        'fullName: $fullName, '
        'dateOfBirth: $dateOfBirth, '
        'calculatedAt: $calculatedAt, '
        'driverNumber: $driverNumber, '
        'destinyNumber: $destinyNumber, '
        'loshuGrid: $loshuGrid, '
        'missingNumbers: $missingNumbers, '
        'magicalNumbers: $magicalNumbers, '
        'firstNameNumber: $firstNameNumber, '
        'fullNameNumber: $fullNameNumber, '
        'personalYear: $personalYear, '
        'personalMonth: $personalMonth, '
        'personalDay: $personalDay, '
        'nameCompatibility: $nameCompatibility, '
        'driverDestinyMeaning: $driverDestinyMeaning, '
        'planetaryRuler: $planetaryRuler'
        ')';
  }

  /// Get formatted Loshu Grid as a 3x3 matrix string
  String getLoshuGridFormatted() {
    const gridPositions = [
      [4, 9, 2],
      [3, 5, 7],
      [8, 1, 6]
    ];
    
    StringBuffer buffer = StringBuffer();
    buffer.writeln('LOSHU GRID (3x3):');
    buffer.writeln('─────────────────');
    
    for (List<int> row in gridPositions) {
      String rowString = '';
      for (int position in row) {
        int count = loshuGrid[position] ?? 0;
        String cell = count == 0 ? '  -  ' : ' ${position.toString().padLeft(2)} ';
        if (count > 1) {
          cell = ' ${position.toString()}×$count';
        }
        rowString += '│$cell';
      }
      buffer.writeln('$rowString│');
      buffer.writeln('─────────────────');
    }
    
    return buffer.toString();
  }

  /// Get detailed analysis summary
  String getDetailedAnalysis() {
    StringBuffer analysis = StringBuffer();
    
    analysis.writeln('=== NUMEROLOGY ANALYSIS FOR ${fullName.toUpperCase()} ===\n');
    
    // Basic Numbers
    analysis.writeln('CORE NUMBERS:');
    analysis.writeln('• Driver Number (Mulank): $driverNumber - Ruled by $planetaryRuler');
    analysis.writeln('• Destiny Number (Bhagyank): $destinyNumber');
    analysis.writeln('• Life Path Number: $lifePathNumber');
    analysis.writeln('• Birthday Number: $birthdayNumber');
    analysis.writeln('• Expression Number: $expressionNumber');
    analysis.writeln('• Soul Urge Number: $soulUrgeNumber');
    analysis.writeln('• Personality Number: $personalityNumber\n');
    
    // Name Numbers
    analysis.writeln('NAME NUMEROLOGY:');
    analysis.writeln('• First Name Number: $firstNameNumber');
    analysis.writeln('• Full Name Number: $fullNameNumber\n');
    
    // Driver/Destiny Combination
    analysis.writeln('DRIVER/DESTINY COMBINATION ($driverNumber/$destinyNumber):');
    analysis.writeln('$driverDestinyMeaning\n');
    
    // Current Timing
    analysis.writeln('CURRENT TIMING:');
    analysis.writeln('• Personal Year: $personalYear');
    analysis.writeln('• Personal Month: $personalMonth');
    analysis.writeln('• Personal Day: $personalDay');
    
    List<int> favorable = [1, 3, 5, 6];
    bool favorableYear = favorable.contains(personalYear);
    bool favorableMonth = favorable.contains(personalMonth);
    bool favorableDay = favorable.contains(personalDay);
    
    if (favorableYear || favorableMonth || favorableDay) {
      analysis.writeln('🌟 Current period has favorable aspects!');
    }
    analysis.writeln('');
    
    // Loshu Grid Analysis
    analysis.writeln('LOSHU GRID ANALYSIS:');
    if (magicalNumbers.isNotEmpty) {
      analysis.writeln('• Magical Numbers (Present): ${magicalNumbers.join(', ')}');
    }
    if (missingNumbers.isNotEmpty) {
      analysis.writeln('• Missing Numbers: ${missingNumbers.join(', ')}');
      analysis.writeln('  Remedies recommended for missing numbers.');
    }
    analysis.writeln('');
    
    // Name Compatibility
    analysis.writeln('NAME COMPATIBILITY:');
    analysis.writeln('• First Name with Driver: ${nameCompatibility['firstNameWithDriver']}');
    analysis.writeln('• First Name with Destiny: ${nameCompatibility['firstNameWithDestiny']}');
    analysis.writeln('• Full Name with Driver: ${nameCompatibility['fullNameWithDriver']}');
    analysis.writeln('• Full Name with Destiny: ${nameCompatibility['fullNameWithDestiny']}');
    analysis.writeln('• Recommendation: ${nameCompatibility['recommendation']}\n');
    
    return analysis.toString();
  }

  /// Get remedies and recommendations
  List<String> getRemedies() {
    List<String> remedies = [];
    
    // Yantra remedies for missing numbers
    if (missingNumbers.isNotEmpty) {
      remedies.add('YANTRA REMEDIES FOR MISSING NUMBERS:');
      for (int number in missingNumbers) {
        switch (number) {
          case 1:
            remedies.add('• Surya Yantra - For leadership and confidence');
            break;
          case 2:
            remedies.add('• Chandra Yantra - For emotional balance');
            break;
          case 3:
            remedies.add('• Guru Yantra - For wisdom and creativity');
            break;
          case 4:
            remedies.add('• Rahu Yantra - For discipline and stability');
            break;
          case 5:
            remedies.add('• Budh Yantra - For communication and balance');
            break;
          case 6:
            remedies.add('• Shukra Yantra - For love and harmony');
            break;
          case 7:
            remedies.add('• Ketu Yantra - For spiritual growth');
            break;
          case 8:
            remedies.add('• Shani Yantra - For financial stability');
            break;
          case 9:
            remedies.add('• Mangal Yantra - For energy and service');
            break;
        }
      }
      remedies.add('');
    }
    
    // Name balancing recommendations
    bool hasEnemyCompatibility = nameCompatibility['firstNameWithDriver'] == 'Enemy' ||
                               nameCompatibility['firstNameWithDestiny'] == 'Enemy' ||
                               nameCompatibility['fullNameWithDriver'] == 'Enemy' ||
                               nameCompatibility['fullNameWithDestiny'] == 'Enemy';
    
    if (hasEnemyCompatibility) {
      remedies.add('NAME BALANCING RECOMMENDATIONS:');
      remedies.add('• Consider adjusting name spelling to improve compatibility');
      remedies.add('• No need to change official documents, just usage');
      remedies.add('• Consult numerologist for specific name modifications');
      remedies.add('');
    }
    
    // General recommendations
    remedies.add('GENERAL RECOMMENDATIONS:');
    remedies.add('• Use favorable numbers for important decisions');
    remedies.add('• Plan important events during favorable personal periods');
    remedies.add('• Choose phone numbers, addresses with compatible numbers');
    remedies.add('• Consider gemstones related to your planetary ruler');
    
    return remedies;
  }

  /// Get compatibility with another person
  static String getPersonalCompatibility(NumerologyResult person1, NumerologyResult person2) {
    StringBuffer compatibility = StringBuffer();
    
    compatibility.writeln('=== COMPATIBILITY ANALYSIS ===\n');
    compatibility.writeln('${person1.fullName} (Driver: ${person1.driverNumber}, Destiny: ${person1.destinyNumber})');
    compatibility.writeln('${person2.fullName} (Driver: ${person2.driverNumber}, Destiny: ${person2.destinyNumber})\n');
    
    // Driver compatibility
    String driverCompat = _getCompatibilityType(person1.driverNumber, person2.driverNumber);
    compatibility.writeln('Driver Number Compatibility: $driverCompat');
    
    // Destiny compatibility
    String destinyCompat = _getCompatibilityType(person1.destinyNumber, person2.destinyNumber);
    compatibility.writeln('Destiny Number Compatibility: $destinyCompat');
    
    // Overall recommendation
    if (driverCompat == 'Friendly' && destinyCompat == 'Friendly') {
      compatibility.writeln('\n🌟 Excellent compatibility! This is a very harmonious combination.');
    } else if (driverCompat == 'Enemy' || destinyCompat == 'Enemy') {
      compatibility.writeln('\n⚠️ Some challenges may arise. Communication and understanding will be key.');
    } else {
      compatibility.writeln('\n✓ Good compatibility with balanced energy exchange.');
    }
    
    return compatibility.toString();
  }

  /// Helper method for compatibility analysis
  static String _getCompatibilityType(int number1, int number2) {
    // Simplified compatibility matrix for the model
    const Map<int, Map<String, List<int>>> compatibility = {
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
    
    Map<String, List<int>>? comp = compatibility[number1];
    if (comp == null) return 'Unknown';
    
    if (comp['friendly']?.contains(number2) == true) {
      return 'Friendly';
    } else if (comp['enemy']?.contains(number2) == true) {
      return 'Enemy';
    } else if (comp['neutral']?.contains(number2) == true) {
      return 'Neutral';
    }
    
    return 'Unknown';
  }

  /// Convert to JSON for storage/export
  Map<String, dynamic> toJson() {
    return {
      'lifePathNumber': lifePathNumber,
      'birthdayNumber': birthdayNumber,
      'expressionNumber': expressionNumber,
      'soulUrgeNumber': soulUrgeNumber,
      'personalityNumber': personalityNumber,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'calculatedAt': calculatedAt.toIso8601String(),
      'driverNumber': driverNumber,
      'destinyNumber': destinyNumber,
      // Convert loshuGrid keys to String for Firestore compatibility
      'loshuGrid': loshuGrid.map((k, v) => MapEntry(k.toString(), v)),
      'missingNumbers': missingNumbers,
      'magicalNumbers': magicalNumbers,
      'firstNameNumber': firstNameNumber,
      'fullNameNumber': fullNameNumber,
      'personalYear': personalYear,
      'personalMonth': personalMonth,
      'personalDay': personalDay,
      'nameCompatibility': nameCompatibility,
      'driverDestinyMeaning': driverDestinyMeaning,
      'planetaryRuler': planetaryRuler,
    };
  }

  /// Create from JSON
  factory NumerologyResult.fromJson(Map<String, dynamic> json) {
    return NumerologyResult(
      lifePathNumber: json['lifePathNumber'],
      birthdayNumber: json['birthdayNumber'],
      expressionNumber: json['expressionNumber'],
      soulUrgeNumber: json['soulUrgeNumber'],
      personalityNumber: json['personalityNumber'],
      fullName: json['fullName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      calculatedAt: DateTime.parse(json['calculatedAt']),
      driverNumber: json['driverNumber'],
      destinyNumber: json['destinyNumber'],
      // Convert loshuGrid keys back to int
      loshuGrid: Map<int, int>.from((json['loshuGrid'] as Map).map((k, v) => MapEntry(int.parse(k), v))),
      missingNumbers: List<int>.from(json['missingNumbers']),
      magicalNumbers: List<int>.from(json['magicalNumbers']),
      firstNameNumber: json['firstNameNumber'],
      fullNameNumber: json['fullNameNumber'],
      personalYear: json['personalYear'],
      personalMonth: json['personalMonth'],
      personalDay: json['personalDay'],
      nameCompatibility: Map<String, dynamic>.from(json['nameCompatibility']),
      driverDestinyMeaning: json['driverDestinyMeaning'],
      planetaryRuler: json['planetaryRuler'],
    );
  }
}

@HiveType(typeId: 2)
enum NumerologyType {
  @HiveField(0)
  lifePathNumber,
  
  @HiveField(1)
  birthdayNumber,
  
  @HiveField(2)
  expressionNumber,
  
  @HiveField(3)
  soulUrgeNumber,
  
  @HiveField(4)
  personalityNumber,
  
  @HiveField(5)
  driverNumber,
  
  @HiveField(6)
  destinyNumber,
  
  @HiveField(7)
  firstNameNumber,
  
  @HiveField(8)
  fullNameNumber,
}

extension NumerologyTypeExtension on NumerologyType {
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
        return 'Driver Number (Mulank)';
      case NumerologyType.destinyNumber:
        return 'Destiny Number (Bhagyank)';
      case NumerologyType.firstNameNumber:
        return 'First Name Number';
      case NumerologyType.fullNameNumber:
        return 'Full Name Number';
    }
  }

  String get description {
    switch (this) {
      case NumerologyType.lifePathNumber:
        return 'Your life\'s purpose and the path you\'re meant to walk.';
      case NumerologyType.birthdayNumber:
        return 'Special gifts and talents you possess.';
      case NumerologyType.expressionNumber:
        return 'Your natural abilities and how you express yourself.';
      case NumerologyType.soulUrgeNumber:
        return 'Your inner desires and what motivates you.';
      case NumerologyType.personalityNumber:
        return 'How others perceive you.';
      case NumerologyType.driverNumber:
        return 'Your basic nature and driving force in life.';
      case NumerologyType.destinyNumber:
        return 'Your life\'s destiny and ultimate goal.';
      case NumerologyType.firstNameNumber:
        return 'How you present yourself to the world.';
      case NumerologyType.fullNameNumber:
        return 'Your complete identity and life expression.';
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

/// Additional Hive type for storing compatibility data
@HiveType(typeId: 3)
class CompatibilityResult extends Equatable {
  @HiveField(0)
  final String person1Name;
  
  @HiveField(1)
  final String person2Name;
  
  @HiveField(2)
  final int person1Driver;
  
  @HiveField(3)
  final int person1Destiny;
  
  @HiveField(4)
  final int person2Driver;
  
  @HiveField(5)
  final int person2Destiny;
  
  @HiveField(6)
  final String driverCompatibility;
  
  @HiveField(7)
  final String destinyCompatibility;
  
  @HiveField(8)
  final String overallRating;
  
  @HiveField(9)
  final DateTime calculatedAt;

  const CompatibilityResult({
    required this.person1Name,
    required this.person2Name,
    required this.person1Driver,
    required this.person1Destiny,
    required this.person2Driver,
    required this.person2Destiny,
    required this.driverCompatibility,
    required this.destinyCompatibility,
    required this.overallRating,
    required this.calculatedAt,
  });

  @override
  List<Object> get props => [
        person1Name,
        person2Name,
        person1Driver,
        person1Destiny,
        person2Driver,
        person2Destiny,
        driverCompatibility,
        destinyCompatibility,
        overallRating,
        calculatedAt,
      ];

  @override
  String toString() {
    return 'CompatibilityResult('
        'person1Name: $person1Name, '
        'person2Name: $person2Name, '
        'person1Driver: $person1Driver, '
        'person1Destiny: $person1Destiny, '
        'person2Driver: $person2Driver, '
        'person2Destiny: $person2Destiny, '
        'driverCompatibility: $driverCompatibility, '
        'destinyCompatibility: $destinyCompatibility, '
        'overallRating: $overallRating, '
        'calculatedAt: $calculatedAt'
        ')';
  }
}