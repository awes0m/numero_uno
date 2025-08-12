import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/app_state.dart';
import '../models/user_data.dart';
import '../models/numerology_result.dart';
import '../models/dual_numerology_result.dart';
import '../services/numerology_service.dart';
import '../services/storage_service.dart';

// Service providers
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService.instance,
);

// App state provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((
  ref,
) {
  return AppStateNotifier(ref);
});

// Numerology result provider
final numerologyResultProvider =
    FutureProvider.family<NumerologyResult, UserData>((ref, userData) async {
      return NumerologyService.calculate(
        dob: userData.dateOfBirth,
        fullName: userData.fullName,
      );
    });

// Storage providers with safety checks
final userInputHistoryProvider = Provider<List<UserData>>((ref) {
  if (!StorageService.canPerformStorageOperations) {
    return <UserData>[];
  }
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getUserInputs();
});

final numerologyHistoryProvider = Provider<List<NumerologyResult>>((ref) {
  if (!StorageService.canPerformStorageOperations) {
    return <NumerologyResult>[];
  }
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getNumerologyResults();
});

final lastCalculationProvider = Provider<NumerologyResult?>((ref) {
  if (!StorageService.canPerformStorageOperations) {
    return null;
  }
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getLastCalculation();
});

// Compatibility was removed from storage; keep a placeholder empty provider
final compatibilityHistoryProvider = Provider<List<Map<String, dynamic>>>((
  ref,
) {
  return const <Map<String, dynamic>>[];
});

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Theme Notifier
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    switch (state) {
      case ThemeMode.system:
        state = ThemeMode.light;
        break;
      case ThemeMode.light:
        state = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        state = ThemeMode.system;
        break;
    }
  }

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
  }

  IconData get themeIcon {
    switch (state) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }

  String get themeLabel {
    switch (state) {
      case ThemeMode.system:
        return 'Auto';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}

// App State Notifier
class AppStateNotifier extends StateNotifier<AppState> {
  final Ref ref;

  AppStateNotifier(this.ref) : super(const AppState());

  Future<void> calculateNumerology(UserData userData) async {
    try {
      state = state.copyWith(
        status: AppStatus.calculating,
        userInput: userData,
        isLoading: true,
        errorMessage: null,
      );

      // Use email as unique user ID
      final userId = userData.email.trim().toLowerCase();

      // Check if storage operations are safe before proceeding
      if (StorageService.canPerformStorageOperations) {
        // Save user input locally only
        final storageService = ref.read(storageServiceProvider);
        await storageService.saveUserInput(
          userData,
          userId: userId,
          isGuest: true,
        );
      }

      // Calculate numerology based on selected system
      NumerologyResult? pythagoreanResult;
      NumerologyResult? chaldeanResult;

      if (userData.selectedSystem == 'pythagorean' ||
          userData.selectedSystem == 'both') {
        pythagoreanResult = NumerologyService.calculate(
          dob: userData.dateOfBirth,
          fullName: userData.fullName,
          system: NumerologyService.pYTHAGOREAN,
        );
      }

      if (userData.selectedSystem == 'chaldean' ||
          userData.selectedSystem == 'both') {
        chaldeanResult = NumerologyService.calculate(
          dob: userData.dateOfBirth,
          fullName: userData.fullName,
          system: NumerologyService.cHALDEAN,
        );
      }

      final dualResult = DualNumerologyResult(
        pythagoreanResult: pythagoreanResult,
        chaldeanResult: chaldeanResult,
        selectedSystem: userData.selectedSystem,
        calculatedAt: DateTime.now(),
      );

      // Save primary result to both local storage and Firestore if storage is available
      if (StorageService.canPerformStorageOperations &&
          dualResult.primaryResult != null) {
        final storageService = ref.read(storageServiceProvider);

        // Save user input first
        await storageService.saveUserInput(
          userData,
          userId: userData.email.trim(),
          isGuest: false,
        );

        // Save numerology result
        await storageService.saveNumerologyResult(
          dualResult.primaryResult!,
          userId: userData.email.trim(),
          isGuest: false,
        );
      }

      state = state.copyWith(
        status: AppStatus.calculated,
        dualNumerologyResult: dualResult,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: AppStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void reset() {
    state = const AppState();
  }
}
