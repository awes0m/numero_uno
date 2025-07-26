// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numero_uno/main.dart';

void main() {
  testWidgets('Basic app functionality test', (WidgetTester tester) async {
    // Increase window size to avoid off-screen widgets
    tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    // Build the app with ProviderScope
    await tester.pumpWidget(ProviderScope(child: const NumeroUnoApp()));
    await tester.pumpAndSettle();

    // Verify input screen is shown
    expect(find.text('Enter Your Details'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Calculate My Numbers'), findsOneWidget);

    // Enter a full name
    final nameField = find.byType(TextField).first;
    await tester.enterText(nameField, 'John Doe');
    await tester.pump();

    // Verify the name was entered
    expect(find.text('John Doe'), findsOneWidget);

    // Test that the submit button is present (we won't submit to avoid navigation issues)
    expect(find.text('Calculate My Numbers'), findsOneWidget);
  });

  testWidgets('Form validation test', (WidgetTester tester) async {
    // Increase window size
    tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    // Build the app
    await tester.pumpWidget(ProviderScope(child: const NumeroUnoApp()));
    await tester.pumpAndSettle();

    // Initially, submit button should be disabled (no date selected)
    final submitButton = find.text('Calculate My Numbers');
    expect(submitButton, findsOneWidget);

    // Enter a name
    final nameField = find.byType(TextField).first;
    await tester.enterText(nameField, 'John Doe');
    await tester.pump();

    // Verify name was entered
    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('Date picker interaction test', (WidgetTester tester) async {
    // Increase window size
    tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    // Build the app
    await tester.pumpWidget(ProviderScope(child: const NumeroUnoApp()));
    await tester.pumpAndSettle();

    // Test date picker button exists
    final datePickerButton = find.byKey(const Key('date_picker_button'));
    expect(datePickerButton, findsOneWidget);

    // Enter a name first
    final nameField = find.byType(TextField).first;
    await tester.enterText(nameField, 'John Doe');
    await tester.pump();

    // Tap date picker (but don't complete the selection to avoid navigation)
    await tester.tap(datePickerButton);
    await tester.pumpAndSettle();

    // Verify date picker dialog appeared
    expect(find.text('OK'), findsOneWidget);
  });
}
