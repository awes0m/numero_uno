import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numero_uno/providers/input_providers.dart';

void main() {
  group('InputViewModel Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be invalid', () {
      final state = container.read(inputFormProvider);

      expect(state.fullName, isEmpty);
      expect(state.email, isEmpty);
      expect(state.dateOfBirth, isNull);
      expect(state.isValid, isFalse);
    });

    test('Valid name should clear error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateFullName('John Doe');
      final state = container.read(inputFormProvider);

      expect(state.fullName, equals('John Doe'));
      expect(state.fullNameError, isNull);
    });

    test('Invalid name should show error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateFullName('123');
      final state = container.read(inputFormProvider);

      expect(state.fullName, equals('123'));
      expect(
        state.fullNameError,
        equals('Name must contain only letters and spaces'),
      );
    });

    test('Empty name should show error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateFullName('');
      final state = container.read(inputFormProvider);

      expect(state.fullName, equals(''));
      expect(state.fullNameError, equals('Name cannot be empty'));
    });

    test('Valid email should clear error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateEmail('john@example.com');
      final state = container.read(inputFormProvider);

      expect(state.email, equals('john@example.com'));
      expect(state.emailError, isNull);
    });

    test('Invalid email should show error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateEmail('invalid-email');
      final state = container.read(inputFormProvider);

      expect(state.email, equals('invalid-email'));
      expect(state.emailError, equals('Enter a valid email address'));
    });

    test('Empty email should show error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateEmail('');
      final state = container.read(inputFormProvider);

      expect(state.email, equals(''));
      expect(state.emailError, equals('Email cannot be empty'));
    });

    test('Valid date should clear error', () {
      final notifier = container.read(inputFormProvider.notifier);
      final validDate = DateTime(2000, 1, 1);

      notifier.updateDateOfBirth(validDate);
      final state = container.read(inputFormProvider);

      expect(state.dateOfBirth, equals(validDate));
      expect(state.dateOfBirthError, isNull);
    });

    test('Future date should show error', () {
      final notifier = container.read(inputFormProvider.notifier);
      final futureDate = DateTime.now().add(const Duration(days: 1));

      notifier.updateDateOfBirth(futureDate);
      final state = container.read(inputFormProvider);

      expect(state.dateOfBirth, equals(futureDate));
      expect(
        state.dateOfBirthError,
        equals('Date of birth cannot be in the future'),
      );
    });

    test('Null date should show error', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateDateOfBirth(null);
      final state = container.read(inputFormProvider);

      expect(state.dateOfBirth, isNull);
      expect(state.dateOfBirthError, equals('Date of birth is required'));
    });

    test('Form should be valid when all fields are valid', () {
      final notifier = container.read(inputFormProvider.notifier);

      // Update all fields to valid values
      notifier.updateFullName('John Doe');
      notifier.updateEmail('john@example.com');
      notifier.updateDateOfBirth(DateTime(2000, 1, 1));

      final state = container.read(inputFormProvider);

      expect(state.isValid, isTrue);
      expect(state.fullNameError, isNull);
      expect(state.emailError, isNull);
      expect(state.dateOfBirthError, isNull);
    });

    test('Individual field updates should validate all fields', () {
      final notifier = container.read(inputFormProvider.notifier);

      // Update only name, other fields remain empty
      notifier.updateFullName('John Doe');
      var state = container.read(inputFormProvider);

      expect(state.fullName, equals('John Doe'));
      expect(state.fullNameError, isNull); // Name is valid
      expect(
        state.emailError,
        equals('Email cannot be empty'),
      ); // Email still empty
      expect(
        state.dateOfBirthError,
        equals('Date of birth is required'),
      ); // Date still null
      expect(
        state.isValid,
        isFalse,
      ); // Form invalid because email and date are missing

      // Now update email
      notifier.updateEmail('john@example.com');
      state = container.read(inputFormProvider);

      expect(state.emailError, isNull); // Email now valid
      expect(
        state.dateOfBirthError,
        equals('Date of birth is required'),
      ); // Date still null
      expect(
        state.isValid,
        isFalse,
      ); // Form still invalid because date is missing

      // Finally update date
      notifier.updateDateOfBirth(DateTime(2000, 1, 1));
      state = container.read(inputFormProvider);

      expect(state.dateOfBirthError, isNull); // Date now valid
      expect(state.isValid, isTrue); // Form now fully valid
    });

    test('Form should be invalid if any field is invalid', () {
      final notifier = container.read(inputFormProvider.notifier);

      // Valid name and email, but no date
      notifier.updateFullName('John Doe');
      notifier.updateEmail('john@example.com');

      final state = container.read(inputFormProvider);

      expect(state.isValid, isFalse);
      expect(state.dateOfBirthError, equals('Date of birth is required'));
    });

    test('createUserData should return null for invalid form', () {
      final notifier = container.read(inputFormProvider.notifier);

      // Only fill name, leave others empty
      notifier.updateFullName('John Doe');

      final userData = notifier.createUserData();

      expect(userData, isNull);
    });

    test('createUserData should return UserData for valid form', () {
      final notifier = container.read(inputFormProvider.notifier);

      notifier.updateFullName('John Doe');
      notifier.updateEmail('john@example.com');
      notifier.updateDateOfBirth(DateTime(2000, 1, 1));

      final userData = notifier.createUserData();

      expect(userData, isNotNull);
      expect(userData!.fullName, equals('John Doe'));
      expect(userData.email, equals('john@example.com'));
      expect(userData.dateOfBirth, equals(DateTime(2000, 1, 1)));
    });
  });
}
