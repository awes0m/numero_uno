import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_data.dart';

class InputFormState {
  final String fullName;
  final DateTime? dateOfBirth;
  final String? fullNameError;
  final String? dateOfBirthError;
  final bool isValid;

  const InputFormState({
    this.fullName = '',
    this.dateOfBirth,
    this.fullNameError,
    this.dateOfBirthError,
    this.isValid = false,
  });

  InputFormState copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? fullNameError,
    String? dateOfBirthError,
    bool? isValid,
  }) {
    return InputFormState(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      fullNameError: fullNameError ?? this.fullNameError,
      dateOfBirthError: dateOfBirthError ?? this.dateOfBirthError,
      isValid: isValid ?? this.isValid,
    );
  }
}

class InputViewModel extends StateNotifier<InputFormState> {
  InputViewModel() : super(const InputFormState());

  void updateFullName(String fullName) {
    final error = _validateFullName(fullName);
    state = state.copyWith(
      fullName: fullName,
      fullNameError: error,
      isValid: _isFormValid(fullName, state.dateOfBirth),
    );
  }

  void updateDateOfBirth(DateTime? dateOfBirth) {
    final error = _validateDateOfBirth(dateOfBirth);
    state = state.copyWith(
      dateOfBirth: dateOfBirth,
      dateOfBirthError: error,
      isValid: _isFormValid(state.fullName, dateOfBirth),
    );
  }

  UserData? createUserData() {
    if (state.isValid) {
      return UserData(
        fullName: state.fullName.trim(),
        dateOfBirth: state.dateOfBirth!,
        createdAt: DateTime.now(),
      );
    }
    return null;
  }

  String? _validateFullName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim())) {
      return 'Name must contain only letters and spaces';
    }
    return null;
  }

  String? _validateDateOfBirth(DateTime? dob) {
    if (dob == null) {
      return 'Date of birth is required';
    }
    if (dob.isAfter(DateTime.now())) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }

  bool _isFormValid(String? name, DateTime? dob) {
    return _validateFullName(name) == null && _validateDateOfBirth(dob) == null;
  }

  void reset() {
    state = const InputFormState();
  }
}
