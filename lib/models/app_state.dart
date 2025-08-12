import 'package:equatable/equatable.dart';
import 'numerology_result.dart';
import 'dual_numerology_result.dart';
import 'user_data.dart';

enum AppStatus { initial, loading, calculating, calculated, error }

class AppState extends Equatable {
  final AppStatus status;
  final UserData? userInput;
  final DualNumerologyResult? dualNumerologyResult;
  final String? errorMessage;
  final bool isLoading;

  const AppState({
    this.status = AppStatus.initial,
    this.userInput,
    this.dualNumerologyResult,
    this.errorMessage,
    this.isLoading = false,
  });

  // Backward compatibility getter
  NumerologyResult? get numerologyResult => dualNumerologyResult?.primaryResult;

  AppState copyWith({
    AppStatus? status,
    UserData? userInput,
    DualNumerologyResult? dualNumerologyResult,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AppState(
      status: status ?? this.status,
      userInput: userInput ?? this.userInput,
      dualNumerologyResult: dualNumerologyResult ?? this.dualNumerologyResult,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userInput,
    dualNumerologyResult,
    errorMessage,
    isLoading,
  ];

  @override
  String toString() {
    return 'AppState(status: $status,  userInput: $userInput, dualNumerologyResult: $dualNumerologyResult, errorMessage: $errorMessage, isLoading: $isLoading)';
  }
}
