import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numero_uno/config/app_theme.dart';
import 'views/screens/welcome_screen.dart';
import 'views/widgets/app_header.dart';

final initializationProvider = FutureProvider<void>((ref) async {
  // Simulate some initialization tasks
  await Future.delayed(
    const Duration(seconds: 3),
  ); // e.g., fetching data, initializing services
  print('Initialization complete!');
});

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializationState = ref.watch(initializationProvider);

    return initializationState.when(
      data: (_) {
        // Data loaded, navigate to home screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        });
        return Scaffold(
          body: Center(
            child: AppHeader(context: context)
                .animate()
                .fadeIn(duration: AppTheme.mediumAnimation)
                .slideY(begin: -0.3, end: 0),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppHeader(context: context),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
