// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:numero_uno/main.dart';
// import 'package:numero_uno/models/app_state.dart';
// import 'package:numero_uno/providers/app_providers.dart';
// import 'package:numero_uno/providers/input_providers.dart';
// import 'package:numero_uno/services/storage_service.dart';
// import 'package:numero_uno/views/screens/welcome_screen.dart';

// import 'widget_test.mocks.dart';

// @GenerateMocks([StorageService])
// void main() {
//   late MockStorageService mockStorageService;

//   setUp(() {
//     mockStorageService = MockStorageService();

//     // Mock default returns
//     when(mockStorageService.getUserInputs()).thenReturn([]);
//     when(mockStorageService.getNumerologyResults()).thenReturn([]);
//     when(mockStorageService.getLastCalculation()).thenReturn(null);
//     when(mockStorageService.saveUserInput(any)).thenAnswer((_) async {});
//     when(mockStorageService.saveNumerologyResult(any)).thenAnswer((_) async {});
//     // when(
//     //   mockStorageService.saveNumerologyResultToFirestoreByName(any),
//     // ).thenAnswer((_) async {});
//     // when(
//     //   mockStorageService.getNumerologyResultByUserId(any),
//     // ).thenAnswer((_) async => null);
//   });

//   Widget createTestApp() {
//     return ProviderScope(
//       overrides: [storageServiceProvider.overrideWithValue(mockStorageService)],
//       child: const NumeroUnoApp(),
//     );
//   }

//   testWidgets('Input validation: empty fields', (WidgetTester tester) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     // Find the WelcomeScreen
//     expect(find.byType(WelcomeScreen), findsOneWidget);

//     // Try to submit with all fields empty
//     await tester.tap(find.text('Calculate My Numbers'));
//     await tester.pumpAndSettle();

//     // Check for validation errors
//     expect(
//       find.text(
//         'Please enter your full name, email, and select your date of birth.',
//       ),
//       findsOneWidget,
//     );
//   });

//   testWidgets('Input validation: invalid name and email', (
//     WidgetTester tester,
//   ) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     // Find text fields and enter invalid data
//     final nameField = find.byType(TextField).at(0);
//     final emailField = find.byType(TextField).at(1);

//     await tester.enterText(nameField, '1234');
//     await tester.enterText(emailField, 'not-an-email');
//     await tester.pumpAndSettle();

//     await tester.tap(find.text('Calculate My Numbers'));
//     await tester.pumpAndSettle();

//     expect(
//       find.text('Name must contain only letters and spaces'),
//       findsOneWidget,
//     );
//     expect(find.text('Enter a valid email address'), findsOneWidget);
//   });

//   testWidgets('Input validation: future date', (WidgetTester tester) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     // Fill valid name and email first
//     final nameField = find.byType(TextField).at(0);
//     final emailField = find.byType(TextField).at(1);

//     await tester.enterText(nameField, 'John Doe');
//     await tester.enterText(emailField, 'john@example.com');
//     await tester.pumpAndSettle();

//     // Set a future date directly in the form state
//     final now = DateTime.now();
//     final futureDate = DateTime(now.year + 10, now.month, now.day);

//     // Find the ProviderScope and set the future date
//     final container = ProviderScope.containerOf(
//       tester.element(find.byType(MaterialApp)),
//     );
//     container.read(inputFormProvider.notifier).updateDateOfBirth(futureDate);
//     await tester.pumpAndSettle();

//     await tester.tap(find.text('Calculate My Numbers'));
//     await tester.pumpAndSettle();

//     expect(find.text('Date of birth cannot be in the future'), findsOneWidget);
//   });

//   testWidgets('Full valid flow: submit and navigate to result', (
//     WidgetTester tester,
//   ) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     // Fill valid data
//     final nameField = find.byType(TextField).at(0);
//     final emailField = find.byType(TextField).at(1);

//     await tester.enterText(nameField, 'John Doe');
//     await tester.enterText(emailField, 'john@example.com');

//     // Set a valid date
//     final validDate = DateTime(2000, 1, 1);
//     final container = ProviderScope.containerOf(
//       tester.element(find.byType(MaterialApp)),
//     );

//     // Update form state directly to ensure validity
//     container.read(inputFormProvider.notifier).updateFullName('John Doe');
//     container.read(inputFormProvider.notifier).updateEmail('john@example.com');
//     container.read(inputFormProvider.notifier).updateDateOfBirth(validDate);
//     await tester.pump();

//     // Verify form is valid before submission
//     expect(container.read(inputFormProvider).isValid, isTrue);

//     await tester.tap(find.text('Calculate My Numbers'));
//     await tester.pump(); // Don't use pumpAndSettle to avoid timeout

//     // Should transition to calculating state after submission
//     final appState = container.read(appStateProvider);
//     expect(appState.status, equals(AppStatus.calculating));
//   });

//   testWidgets('Form state updates correctly', (WidgetTester tester) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     final container = ProviderScope.containerOf(
//       tester.element(find.byType(MaterialApp)),
//     );

//     // Verify initial state
//     expect(container.read(inputFormProvider).fullName, isEmpty);
//     expect(container.read(inputFormProvider).email, isEmpty);
//     expect(container.read(inputFormProvider).isValid, isFalse);

//     // Update all fields to valid values
//     container.read(inputFormProvider.notifier).updateFullName('John Doe');
//     container.read(inputFormProvider.notifier).updateEmail('john@example.com');
//     container
//         .read(inputFormProvider.notifier)
//         .updateDateOfBirth(DateTime(2000, 1, 1));
//     await tester.pump();

//     final state = container.read(inputFormProvider);
//     expect(state.fullName, equals('John Doe'));
//     expect(state.email, equals('john@example.com'));
//     expect(state.fullNameError, isNull);
//     expect(state.emailError, isNull);
//     expect(state.dateOfBirthError, isNull);
//     expect(state.isValid, isTrue);
//   });

//   testWidgets('Validation updates on field changes', (
//     WidgetTester tester,
//   ) async {
//     tester.view.physicalSize = const Size(1200, 1600);
//     tester.view.devicePixelRatio = 1.0;
//     addTearDown(() {
//       tester.view.resetPhysicalSize();
//       tester.view.resetDevicePixelRatio();
//     });

//     await tester.pumpWidget(createTestApp());
//     await tester.pumpAndSettle();

//     final container = ProviderScope.containerOf(
//       tester.element(find.byType(MaterialApp)),
//     );

//     // Test invalid name
//     container.read(inputFormProvider.notifier).updateFullName('123');
//     expect(
//       container.read(inputFormProvider).fullNameError,
//       'Name must contain only letters and spaces',
//     );

//     // Test invalid email
//     container.read(inputFormProvider.notifier).updateEmail('invalid-email');
//     expect(
//       container.read(inputFormProvider).emailError,
//       'Enter a valid email address',
//     );

//     // Test future date
//     final futureDate = DateTime.now().add(const Duration(days: 1));
//     container.read(inputFormProvider.notifier).updateDateOfBirth(futureDate);
//     expect(
//       container.read(inputFormProvider).dateOfBirthError,
//       'Date of birth cannot be in the future',
//     );

//     // Fix all fields
//     container.read(inputFormProvider.notifier).updateFullName('John Doe');
//     container.read(inputFormProvider.notifier).updateEmail('john@example.com');
//     container
//         .read(inputFormProvider.notifier)
//         .updateDateOfBirth(DateTime(2000, 1, 1));

//     final state = container.read(inputFormProvider);
//     expect(state.fullNameError, isNull);
//     expect(state.emailError, isNull);
//     expect(state.dateOfBirthError, isNull);
//     expect(state.isValid, isTrue);
//   });
// }
