import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/app_theme.dart';
import 'providers/app_providers.dart';
import 'services/storage_service.dart';
import 'views/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = StorageService();
  try {
    await storageService.initialize();
  } catch (e) {
    debugPrint('Storage initialization failed: $e');
  }

  // Run the app with a ProviderScope
  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const NumeroUnoApp(),
    ),
  );
}

class NumeroUnoApp extends ConsumerWidget {
  const NumeroUnoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Numero Uno - Numerology Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
