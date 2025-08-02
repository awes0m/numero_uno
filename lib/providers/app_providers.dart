import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/app_state.dart';
import '../models/user_data.dart';
import '../models/numerology_result.dart';
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
      return await NumerologyService.calculateNumerology(userData);
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

final compatibilityHistoryProvider = Provider<List<CompatibilityResult>>((ref) {
  if (!StorageService.canPerformStorageOperations) {
    return <CompatibilityResult>[];
  }
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getCompatibilityResults();
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

      // Calculate numerology
      final result = await NumerologyService.calculateNumerology(userData);

      // Save result locally only if storage is available
      if (StorageService.canPerformStorageOperations) {
        final storageService = ref.read(storageServiceProvider);
        await storageService.saveNumerologyResult(
          result,
          userId: userId,
          isGuest: true,
        );
      }

      state = state.copyWith(
        status: AppStatus.calculated,
        numerologyResult: result,
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

  /// Call this after results are displayed to upload to Firebase
  Future<void> uploadResultsToFirebase() async {
    try {
      final userData = state.userInput;
      final result = state.numerologyResult;
      if (userData == null || result == null) return;

      // Check if storage operations are safe before proceeding
      if (!StorageService.canPerformStorageOperations) return;

      final userId = userData.email.trim().toLowerCase();
      final storageService = ref.read(storageServiceProvider);
      await storageService.saveUserInput(
        userData,
        userId: userId,
        isGuest: false,
      );
      await storageService.saveNumerologyResult(
        result,
        userId: userId,
        isGuest: false,
      );
    } catch (e) {
      // Optionally handle upload error
      debugPrint('❌ Error uploading to Firebase: $e');
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
