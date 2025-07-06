import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_state.dart';
import '../models/user_input.dart';
import '../models/numerology_result.dart';
import '../services/auth_service.dart';
import '../services/numerology_service.dart';
import '../services/storage_service.dart';

// Service providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, _) => null,
  );
});

// App state provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier(ref);
});

// User input form provider
final userInputFormProvider = StateNotifierProvider<UserInputFormNotifier, UserInputFormState>((ref) {
  return UserInputFormNotifier();
});

// Numerology result provider
final numerologyResultProvider = FutureProvider.family<NumerologyResult, UserInput>((ref, userInput) async {
  return await NumerologyService.calculateNumerology(userInput);
});

// Storage providers
final userInputHistoryProvider = Provider.family<List<UserInput>, String?>((ref, userId) {
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getUserInputs(userId);
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

  AppStateNotifier(this.ref) : super(const AppState()) {
    _initialize();
  }

  void _initialize() {
    // Listen to auth state changes
    ref.listen(authStateProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            state = state.copyWith(
              status: AppStatus.authenticated,
              user: user,
            );
          } else {
            state = state.copyWith(
              status: AppStatus.unauthenticated,
              user: null,
            );
          }
        },
        loading: () {
          state = state.copyWith(isLoading: true);
        },
        error: (error, stackTrace) {
          state = state.copyWith(
            status: AppStatus.error,
            errorMessage: error.toString(),
            isLoading: false,
          );
        },
      );
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(
        status: AppStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signInAnonymously() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final authService = ref.read(authServiceProvider);
      await authService.signInAnonymously();
    } catch (e) {
      state = state.copyWith(
        status: AppStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      
      // Clear user-specific data
      state = state.copyWith(
        status: AppStatus.unauthenticated,
        user: null,
        userInput: null,
        numerologyResult: null,
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

  Future<void> calculateNumerology(UserInput userInput) async {
    try {
      state = state.copyWith(
        status: AppStatus.calculating,
        userInput: userInput,
        isLoading: true,
        errorMessage: null,
      );

      // Save user input
      final storageService = ref.read(storageServiceProvider);
      await storageService.saveUserInput(userInput);

      // Calculate numerology
      final result = await NumerologyService.calculateNumerology(userInput);
      
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
    state = state.copyWith(errorMessage: null);
  }

  void reset() {
    state = const AppState();
  }
}

// User Input Form State
class UserInputFormState {
  final String fullName;
  final DateTime? dateOfBirth;
  final String? fullNameError;
  final String? dateOfBirthError;
  final bool isValid;

  const UserInputFormState({
    this.fullName = '',
    this.dateOfBirth,
    this.fullNameError,
    this.dateOfBirthError,
    this.isValid = false,
  });

  UserInputFormState copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? fullNameError,
    String? dateOfBirthError,
    bool? isValid,
  }) {
    return UserInputFormState(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      fullNameError: fullNameError ?? this.fullNameError,
      dateOfBirthError: dateOfBirthError ?? this.dateOfBirthError,
      isValid: isValid ?? this.isValid,
    );
  }
}

// User Input Form Notifier
class UserInputFormNotifier extends StateNotifier<UserInputFormState> {
  UserInputFormNotifier() : super(const UserInputFormState());

  void updateFullName(String fullName) {
    final error = _validateFullName(fullName);
    state = state.copyWith(
      fullName: fullName,
      fullNameError: error,
      isValid: _isFormValid(fullName, state.dateOfBirth, error, state.dateOfBirthError),
    );
  }

  void updateDateOfBirth(DateTime dateOfBirth) {
    final error = _validateDateOfBirth(dateOfBirth);
    state = state.copyWith(
      dateOfBirth: dateOfBirth,
      dateOfBirthError: error,
      isValid: _isFormValid(state.fullName, dateOfBirth, state.fullNameError, error),
    );
  }

  String? _validateFullName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'Full name is required';
    }
    if (fullName.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateDateOfBirth(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    
    if (dateOfBirth.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }
    if (age > 150) {
      return 'Please enter a valid date of birth';
    }
    return null;
  }

  bool _isFormValid(String fullName, DateTime? dateOfBirth, String? nameError, String? dateError) {
    return fullName.trim().isNotEmpty &&
           dateOfBirth != null &&
           nameError == null &&
           dateError == null;
  }

  void reset() {
    state = const UserInputFormState();
  }

  UserInput? createUserInput(String? userId) {
    if (!state.isValid || state.dateOfBirth == null) {
      return null;
    }

    return UserInput(
      fullName: state.fullName.trim(),
      dateOfBirth: state.dateOfBirth!,
      userId: userId,
      createdAt: DateTime.now(),
    );
  }
}