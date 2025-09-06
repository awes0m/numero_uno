import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/app_theme.dart';
import 'firebase_options.dart';
import 'providers/app_providers.dart';
import 'services/storage_service.dart';
import 'splashscreen.dart';
import 'views/screens/result_overview_screen.dart';
import 'views/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage with detailed error handling
  try {
    debugPrint('🚀 Initializing storage services...');
    await StorageService.initialize();
    debugPrint('✅ Storage services initialized successfully');

    // Print initialization status for debugging
    final status = StorageService.getInitializationStatus();
    debugPrint('📊 Storage initialization status: $status');
  } catch (e, stackTrace) {
    debugPrint('❌ Storage initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    // Continue app execution even if storage fails
  }

  // Initialize Firebase
  try {
    debugPrint('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Firebase initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // Run the app with a ProviderScope
  runApp(const ProviderScope(child: NumeroUnoApp()));
}

class NumeroUnoApp extends ConsumerStatefulWidget {
  const NumeroUnoApp({super.key});

  @override
  ConsumerState<NumeroUnoApp> createState() => _NumeroUnoAppState();
}

class _NumeroUnoAppState extends ConsumerState<NumeroUnoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // App is being terminated, close storage
      if (StorageService.isInitialized) {
        StorageService.instance.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Numero Uno - Numerology Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
      routes: {
        '/calculation': (context) => const WelcomeScreen(),
        '/resultOverview': (context) => const ResultOverviewScreen(),
      },
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
