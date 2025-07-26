import 'package:equatable/equatable.dart';
import 'numerology_result.dart';
import 'user_data.dart';

enum AppStatus { initial, loading, calculating, calculated, error }

class AppState extends Equatable {
  final AppStatus status;
  final UserData? userInput;
  final NumerologyResult? numerologyResult;
  final String? errorMessage;
  final bool isLoading;

  const AppState({
    this.status = AppStatus.initial,
    this.userInput,
    this.numerologyResult,
    this.errorMessage,
    this.isLoading = false,
  });

  AppState copyWith({
    AppStatus? status,
    UserData? userInput,
    NumerologyResult? numerologyResult,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AppState(
      status: status ?? this.status,
      userInput: userInput ?? this.userInput,
      numerologyResult: numerologyResult ?? this.numerologyResult,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userInput,
    numerologyResult,
    errorMessage,
    isLoading,
  ];

  @override
  String toString() {
    return 'AppState(status: $status,  userInput: $userInput, numerologyResult: $numerologyResult, errorMessage: $errorMessage, isLoading: $isLoading)';
  }
}
