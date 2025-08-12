// ---------------------------- numerology_result.dart ----------------------------
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'numerology_result.g.dart';

@HiveType(typeId: 1)
class NumerologyResult extends Equatable {
  // Core numbers
  @HiveField(0)
  final int lifePathNumber;

  @HiveField(1)
  final int birthdayNumber;

  @HiveField(2)
  final int expressionNumber;

  @HiveField(3)
  final int soulUrgeNumber; // Hearts Desire

  @HiveField(4)
  final int personalityNumber;

  // Basic identity
  @HiveField(5)
  final String fullName;

  @HiveField(6)
  final DateTime dateOfBirth;

  @HiveField(7)
  final DateTime calculatedAt;

  // Additional core/enhanced numbers
  @HiveField(8)
  final int driverNumber;

  @HiveField(9)
  final int destinyNumber;

  @HiveField(10)
  final Map<int, int> loshuGrid;

  @HiveField(11)
  final List<int> missingNumbers;

  @HiveField(12)
  final List<int> magicalNumbers;

  @HiveField(13)
  final int firstNameNumber;

  @HiveField(14)
  final int fullNameNumber;

  // Pinnacles & Challenges
  @HiveField(15)
  final Map<String, int> pinnacles; // keys: p1..p4

  @HiveField(16)
  final Map<String, int> challenges; // keys: c1..c4

  // Timing
  @HiveField(17)
  final Map<String, int> personalYears; // "2024": 7 etc.

  @HiveField(18)
  final Map<String, int> essences; // "2024": 3 etc.

  // Karmic / special
  @HiveField(19)
  final int hiddenPassionNumber;

  @HiveField(20)
  final List<int> karmicLessons;

  @HiveField(21)
  final List<int> karmicDebts;

  // Compatibility / analysis buckets (flexible map so it can grow without code change)
  @HiveField(22)
  final Map<String, dynamic> nameCompatibility;

  @HiveField(23)
  final Map<String, dynamic> detailedAnalysis;

  @HiveField(24)
  final String systemUsed; // "Pythagorean" or "Chaldean"

  const NumerologyResult({
    required this.lifePathNumber,
    required this.birthdayNumber,
    required this.expressionNumber,
    required this.soulUrgeNumber,
    required this.personalityNumber,
    required this.fullName,
    required this.dateOfBirth,
    required this.calculatedAt,
    required this.driverNumber,
    required this.destinyNumber,
    required this.loshuGrid,
    required this.missingNumbers,
    required this.magicalNumbers,
    required this.firstNameNumber,
    required this.fullNameNumber,
    required this.pinnacles,
    required this.challenges,
    required this.personalYears,
    required this.essences,
    required this.hiddenPassionNumber,
    required this.karmicLessons,
    required this.karmicDebts,
    required this.nameCompatibility,
    required this.detailedAnalysis,
    required this.systemUsed,
  });

  NumerologyResult copyWith({
    int? lifePathNumber,
    int? birthdayNumber,
    int? expressionNumber,
    int? soulUrgeNumber,
    int? personalityNumber,
    String? fullName,
    DateTime? dateOfBirth,
    DateTime? calculatedAt,
    int? driverNumber,
    int? destinyNumber,
    Map<int, int>? loshuGrid,
    List<int>? missingNumbers,
    List<int>? magicalNumbers,
    int? firstNameNumber,
    int? fullNameNumber,
    Map<String, int>? pinnacles,
    Map<String, int>? challenges,
    Map<String, int>? personalYears,
    Map<String, int>? essences,
    int? hiddenPassionNumber,
    List<int>? karmicLessons,
    List<int>? karmicDebts,
    Map<String, dynamic>? nameCompatibility,
    Map<String, dynamic>? detailedAnalysis,
    String? systemUsed,
  }) {
    return NumerologyResult(
      lifePathNumber: lifePathNumber ?? this.lifePathNumber,
      birthdayNumber: birthdayNumber ?? this.birthdayNumber,
      expressionNumber: expressionNumber ?? this.expressionNumber,
      soulUrgeNumber: soulUrgeNumber ?? this.soulUrgeNumber,
      personalityNumber: personalityNumber ?? this.personalityNumber,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      driverNumber: driverNumber ?? this.driverNumber,
      destinyNumber: destinyNumber ?? this.destinyNumber,
      loshuGrid: loshuGrid ?? this.loshuGrid,
      missingNumbers: missingNumbers ?? this.missingNumbers,
      magicalNumbers: magicalNumbers ?? this.magicalNumbers,
      firstNameNumber: firstNameNumber ?? this.firstNameNumber,
      fullNameNumber: fullNameNumber ?? this.fullNameNumber,
      pinnacles: pinnacles ?? this.pinnacles,
      challenges: challenges ?? this.challenges,
      personalYears: personalYears ?? this.personalYears,
      essences: essences ?? this.essences,
      hiddenPassionNumber: hiddenPassionNumber ?? this.hiddenPassionNumber,
      karmicLessons: karmicLessons ?? this.karmicLessons,
      karmicDebts: karmicDebts ?? this.karmicDebts,
      nameCompatibility: nameCompatibility ?? this.nameCompatibility,
      detailedAnalysis: detailedAnalysis ?? this.detailedAnalysis,
      systemUsed: systemUsed ?? this.systemUsed,
    );
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
      'driverNumber': driverNumber,
      'destinyNumber': destinyNumber,
      'loshuGrid': loshuGrid.map((k, v) => MapEntry(k.toString(), v)),
      'missingNumbers': missingNumbers,
      'magicalNumbers': magicalNumbers,
      'firstNameNumber': firstNameNumber,
      'fullNameNumber': fullNameNumber,
      'pinnacles': Map<String, dynamic>.from(pinnacles),
      'challenges': Map<String, dynamic>.from(challenges),
      'personalYears': Map<String, dynamic>.from(personalYears),
      'essences': Map<String, dynamic>.from(essences),
      'hiddenPassionNumber': hiddenPassionNumber,
      'karmicLessons': karmicLessons,
      'karmicDebts': karmicDebts,
      'nameCompatibility': Map<String, dynamic>.from(nameCompatibility),
      'detailedAnalysis': Map<String, dynamic>.from(detailedAnalysis),
      'systemUsed': systemUsed,
    };
  }

  factory NumerologyResult.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int safeInt(dynamic value, [int defaultValue = 0]) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    // Helper function to safely convert map values to int
    Map<String, int> safeMapStringInt(dynamic value) {
      if (value == null) return <String, int>{};
      final map = Map<String, dynamic>.from(value);
      return map.map((k, v) => MapEntry(k, safeInt(v)));
    }

    return NumerologyResult(
      lifePathNumber: safeInt(json['lifePathNumber']),
      birthdayNumber: safeInt(json['birthdayNumber']),
      expressionNumber: safeInt(json['expressionNumber']),
      soulUrgeNumber: safeInt(json['soulUrgeNumber']),
      personalityNumber: safeInt(json['personalityNumber']),
      fullName: json['fullName'] as String? ?? '',
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      driverNumber: safeInt(json['driverNumber']),
      destinyNumber: safeInt(json['destinyNumber']),
      loshuGrid: () {
        final loshuData = json['loshuGrid'] ?? {};
        final result = <int, int>{};
        if (loshuData is Map) {
          loshuData.forEach((k, v) {
            final key = k is String ? int.tryParse(k) ?? 0 : (k as int? ?? 0);
            result[key] = safeInt(v);
          });
        }
        return result;
      }(),
      missingNumbers:
          (json['missingNumbers'] as List?)?.map((e) => safeInt(e)).toList() ??
          [],
      magicalNumbers:
          (json['magicalNumbers'] as List?)?.map((e) => safeInt(e)).toList() ??
          [],
      firstNameNumber: safeInt(json['firstNameNumber']),
      fullNameNumber: safeInt(json['fullNameNumber']),
      pinnacles: safeMapStringInt(json['pinnacles']),
      challenges: safeMapStringInt(json['challenges']),
      personalYears: safeMapStringInt(json['personalYears']),
      essences: safeMapStringInt(json['essences']),
      hiddenPassionNumber: safeInt(json['hiddenPassionNumber']),
      karmicLessons:
          (json['karmicLessons'] as List?)?.map((e) => safeInt(e)).toList() ??
          [],
      karmicDebts:
          (json['karmicDebts'] as List?)?.map((e) => safeInt(e)).toList() ?? [],
      nameCompatibility: Map<String, dynamic>.from(
        json['nameCompatibility'] ?? {},
      ),
      detailedAnalysis: Map<String, dynamic>.from(
        json['detailedAnalysis'] ?? {},
      ),
      systemUsed: json['systemUsed'] as String? ?? 'Pythagorean',
    );
  }

  @override
  List<Object?> get props => [
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
    pinnacles,
    challenges,
    personalYears,
    essences,
    hiddenPassionNumber,
    karmicLessons,
    karmicDebts,
    nameCompatibility,
    detailedAnalysis,
    systemUsed,
  ];

  @override
  String toString() => 'NumerologyResult(${toJson()})';
}
