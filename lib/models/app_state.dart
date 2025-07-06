import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'numerology_result.dart';
import 'user_input.dart';

enum AppStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  calculating,
  calculated,
  error,
}

class AppState extends Equatable {
  final AppStatus status;
  final User? user;
  final UserInput? userInput;
  final NumerologyResult? numerologyResult;
  final String? errorMessage;
  final bool isLoading;

  const AppState({
    this.status = AppStatus.initial,
    this.user,
    this.userInput,
    this.numerologyResult,
    this.errorMessage,
    this.isLoading = false,
  });

  AppState copyWith({
    AppStatus? status,
    User? user,
    UserInput? userInput,
    NumerologyResult? numerologyResult,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      userInput: userInput ?? this.userInput,
      numerologyResult: numerologyResult ?? this.numerologyResult,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        userInput,
        numerologyResult,
        errorMessage,
        isLoading,
      ];

  @override
  String toString() {
    return 'AppState(status: $status, user: $user, userInput: $userInput, numerologyResult: $numerologyResult, errorMessage: $errorMessage, isLoading: $isLoading)';
  }
}