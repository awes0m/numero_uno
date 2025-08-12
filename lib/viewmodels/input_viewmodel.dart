import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_data.dart';
import '../providers/app_providers.dart';

class InputFormState {
  final String fullName;
  final DateTime? dateOfBirth;
  final String email;
  final String selectedSystem;
  final String? fullNameError;
  final String? dateOfBirthError;
  final String? emailError;
  final bool isValid;

  const InputFormState({
    this.fullName = '',
    this.dateOfBirth,
    this.email = '',
    this.selectedSystem = 'both', // 'pythagorean', 'chaldean', or 'both'
    this.fullNameError,
    this.dateOfBirthError,
    this.emailError,
    this.isValid = false,
  });

  InputFormState copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? email,
    String? selectedSystem,
    String? fullNameError,
    String? dateOfBirthError,
    String? emailError,
    bool? isValid,
  }) {
    return InputFormState(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      email: email ?? this.email,
      selectedSystem: selectedSystem ?? this.selectedSystem,
      fullNameError: fullNameError,
      dateOfBirthError: dateOfBirthError,
      emailError: emailError,
      isValid: isValid ?? this.isValid,
    );
  }
}

class InputViewModel extends StateNotifier<InputFormState> {
  final Ref ref;
  InputViewModel(this.ref) : super(const InputFormState());

  void updateFullName(String fullName) {
    _updateFormState(
      fullName: fullName,
      dateOfBirth: state.dateOfBirth,
      email: state.email,
      selectedSystem: state.selectedSystem,
    );
  }

  void updateDateOfBirth(DateTime? dateOfBirth) {
    _updateFormState(
      fullName: state.fullName,
      dateOfBirth: dateOfBirth,
      email: state.email,
      selectedSystem: state.selectedSystem,
    );
  }

  void updateEmail(String email) {
    _updateFormState(
      fullName: state.fullName,
      dateOfBirth: state.dateOfBirth,
      email: email,
      selectedSystem: state.selectedSystem,
    );
  }

  void updateSelectedSystem(String system) {
    _updateFormState(
      fullName: state.fullName,
      dateOfBirth: state.dateOfBirth,
      email: state.email,
      selectedSystem: system,
    );
  }

  void _updateFormState({
    required String fullName,
    required DateTime? dateOfBirth,
    required String email,
    required String selectedSystem,
  }) {
    final nameError = _validateFullName(fullName);
    final dateError = _validateDateOfBirth(dateOfBirth);
    final emailError = _validateEmail(email);
    final isValid =
        nameError == null && dateError == null && emailError == null;

    state = state.copyWith(
      fullName: fullName,
      dateOfBirth: dateOfBirth,
      email: email,
      selectedSystem: selectedSystem,
      fullNameError: nameError,
      dateOfBirthError: dateError,
      emailError: emailError,
      isValid: isValid,
    );
  }

  UserData? createUserData() {
    if (state.isValid) {
      return UserData(
        fullName: state.fullName.trim(),
        dateOfBirth: state.dateOfBirth!,
        createdAt: DateTime.now(),
        email: state.email.trim(),
        selectedSystem: state.selectedSystem,
      );
    }
    return null;
  }

  String? _validateFullName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(name.trim())) {
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

  String? _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple email regex
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void reset() {
    state = const InputFormState();
  }

  void validateAndSubmit(BuildContext context) {
    updateFullName(state.fullName);
    updateEmail(state.email);
    updateDateOfBirth(state.dateOfBirth);

    if (state.isValid) {
      final userData = createUserData();
      if (userData != null) {
        ref.read(appStateProvider.notifier).calculateNumerology(userData);
      }
    }
  }
}
