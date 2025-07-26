import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/app_state.dart';
import '../models/user_data.dart';
import '../models/numerology_result.dart';
import '../services/numerology_service.dart';
import '../services/storage_service.dart';

// Service providers
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
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

// Storage providers
final userInputHistoryProvider = Provider<List<UserData>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getUserInputs();
});

final numerologyHistoryProvider = Provider<List<NumerologyResult>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getNumerologyResults();
});

final lastCalculationProvider = Provider<NumerologyResult?>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getLastCalculation();
});

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

      // Save user input
      final storageService = ref.read(storageServiceProvider);
      await storageService.saveUserInput(userData);

      // Calculate numerology
      final result = await NumerologyService.calculateNumerology(userData);

      // Save result
      await storageService.saveNumerologyResult(result);

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

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void reset() {
    state = const AppState();
  }
}
