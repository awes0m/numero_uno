import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'numerology_result.g.dart';

@HiveType(typeId: 1)
class NumerologyResult extends Equatable {
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

  const NumerologyResult({
    required this.lifePathNumber,
    required this.birthdayNumber,
    required this.expressionNumber,
    required this.soulUrgeNumber,
    required this.personalityNumber,
    required this.fullName,
    required this.dateOfBirth,
    required this.calculatedAt,
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
      ];

  @override
  String toString() {
    return 'NumerologyResult(lifePathNumber: $lifePathNumber, birthdayNumber: $birthdayNumber, expressionNumber: $expressionNumber, soulUrgeNumber: $soulUrgeNumber, personalityNumber: $personalityNumber, fullName: $fullName, dateOfBirth: $dateOfBirth, calculatedAt: $calculatedAt)';
  }

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
    };
  }
}

@HiveType(typeId: 2)
enum NumerologyType {
  @HiveField(0)
  lifePath,
  
  @HiveField(1)
  birthday,
  
  @HiveField(2)
  expression,
  
  @HiveField(3)
  soulUrge,
  
  @HiveField(4)
  personality,
}

extension NumerologyTypeExtension on NumerologyType {
  String get displayName {
    switch (this) {
      case NumerologyType.lifePath:
        return 'Life Path Number';
      case NumerologyType.birthday:
        return 'Birthday Number';
      case NumerologyType.expression:
        return 'Expression Number';
      case NumerologyType.soulUrge:
        return 'Soul Urge Number';
      case NumerologyType.personality:
        return 'Personality Number';
    }
  }

  String get description {
    switch (this) {
      case NumerologyType.lifePath:
        return 'Your life path number reveals your life\'s purpose and the path you\'re meant to walk.';
      case NumerologyType.birthday:
        return 'Your birthday number represents your natural talents and abilities.';
      case NumerologyType.expression:
        return 'Your expression number reveals your life\'s goal and what you\'re meant to accomplish.';
      case NumerologyType.soulUrge:
        return 'Your soul urge number represents your inner desires and what motivates you.';
      case NumerologyType.personality:
        return 'Your personality number shows how others perceive you and your outer personality.';
    }
  }

  int getValue(NumerologyResult result) {
    switch (this) {
      case NumerologyType.lifePath:
        return result.lifePathNumber;
      case NumerologyType.birthday:
        return result.birthdayNumber;
      case NumerologyType.expression:
        return result.expressionNumber;
      case NumerologyType.soulUrge:
        return result.soulUrgeNumber;
      case NumerologyType.personality:
        return result.personalityNumber;
    }
  }
}