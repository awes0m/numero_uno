import 'package:equatable/equatable.dart';
import 'numerology_result.dart';

/// Model to hold both Pythagorean and Chaldean numerology results
class DualNumerologyResult extends Equatable {
  final NumerologyResult? pythagoreanResult;
  final NumerologyResult? chaldeanResult;
  final String selectedSystem; // 'pythagorean', 'chaldean', or 'both'
  final DateTime calculatedAt;

  const DualNumerologyResult({
    this.pythagoreanResult,
    this.chaldeanResult,
    required this.selectedSystem,
    required this.calculatedAt,
  });

  /// Get the primary result based on selected system
  NumerologyResult? get primaryResult {
    switch (selectedSystem) {
      case 'pythagorean':
        return pythagoreanResult;
      case 'chaldean':
        return chaldeanResult;
      case 'both':
        return pythagoreanResult; // Default to Pythagorean when both are selected
      default:
        return pythagoreanResult;
    }
  }

  /// Check if both systems were calculated
  bool get hasBothResults => pythagoreanResult != null && chaldeanResult != null;

  /// Check if only one system was calculated
  bool get hasSingleResult => (pythagoreanResult != null) ^ (chaldeanResult != null);

  @override
  List<Object?> get props => [
        pythagoreanResult,
        chaldeanResult,
        selectedSystem,
        calculatedAt,
      ];

  DualNumerologyResult copyWith({
    NumerologyResult? pythagoreanResult,
    NumerologyResult? chaldeanResult,
    String? selectedSystem,
    DateTime? calculatedAt,
  }) {
    return DualNumerologyResult(
      pythagoreanResult: pythagoreanResult ?? this.pythagoreanResult,
      chaldeanResult: chaldeanResult ?? this.chaldeanResult,
      selectedSystem: selectedSystem ?? this.selectedSystem,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }
}