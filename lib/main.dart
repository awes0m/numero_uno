import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'config/app_theme.dart';
import 'config/app_router.dart';
import 'services/storage_service.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "your-api-key",
        authDomain: "your-project.firebaseapp.com",
        projectId: "your-project-id",
        storageBucket: "your-project.appspot.com",
        messagingSenderId: "123456789",
        appId: "your-app-id",
      ),
    );
  } catch (e) {
    // Firebase initialization failed, continue without it
    debugPrint('Firebase initialization failed: $e');
  }
  
  // Initialize storage
  final storageService = StorageService();
  try {
    await storageService.initialize();
  } catch (e) {
    debugPrint('Storage initialization failed: $e');
  }
  
  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const NumeroUnoApp(),
    ),
  );
}

class NumeroUnoApp extends ConsumerWidget {
  const NumeroUnoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Numero Uno - Numerology Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
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
