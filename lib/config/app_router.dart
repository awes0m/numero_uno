import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/numerology_result.dart';
import '../models/app_state.dart';
import '../providers/app_providers.dart';
import '../views/screens/welcome_screen.dart';
import '../views/screens/result_overview_screen.dart';
import '../views/screens/detail_screen.dart';
import '../views/screens/loading_screen.dart';
import '../views/screens/error_screen.dart';


// Route names
class AppRoutes {
  static const String welcome = '/';
  static const String loading = '/loading';
  static const String results = '/results';
  static const String detail = '/detail';
  static const String error = '/error';
}

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.loading,
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.results,
        name: 'results',
        builder: (context, state) => const ResultOverviewScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.detail}/:type',
        name: 'detail',
        builder: (context, state) {
          final typeString = state.pathParameters['type']!;
          final type = NumerologyType.values.firstWhere(
            (e) => e.name == typeString,
            orElse: () => NumerologyType.lifePath,
          );
          return DetailScreen(type: type);
        },
      ),
      GoRoute(
        path: AppRoutes.error,
        name: 'error',
        builder: (context, state) {
          final error = state.extra as String? ?? 'An unknown error occurred';
          return ErrorScreen(error: error);
        },
      ),
    ],
    redirect: (context, state) {
      // Get the current app state
      final container = ProviderScope.containerOf(context);
      final appState = container.read(appStateProvider);

      // Handle navigation based on app state
      switch (appState.status) {
        case AppStatus.calculating:
          if (state.matchedLocation != AppRoutes.loading) {
            return AppRoutes.loading;
          }
          break;
        case AppStatus.calculated:
          if (state.matchedLocation == AppRoutes.loading) {
            return AppRoutes.results;
          }
          break;
        case AppStatus.error:
          if (state.matchedLocation != AppRoutes.error) {
            return AppRoutes.error;
          }
          break;
        default:
          break;
      }

      return null; // No redirect needed
    },
    errorBuilder: (context, state) => ErrorScreen(
      error: 'Page not found: ${state.matchedLocation}',
    ),
  );
});

// Navigation helper extension
extension AppNavigation on GoRouter {
  void goToWelcome() => go(AppRoutes.welcome);
  void goToLoading() => go(AppRoutes.loading);
  void goToResults() => go(AppRoutes.results);
  void goToDetail(NumerologyType type) => go('${AppRoutes.detail}/${type.name}');
  void goToError(String error) => go(AppRoutes.error, extra: error);
}

// Navigation helper functions
class AppNavigator {
  static void toWelcome(BuildContext context) {
    GoRouter.of(context).goToWelcome();
  }

  static void toLoading(BuildContext context) {
    GoRouter.of(context).goToLoading();
  }

  static void toResults(BuildContext context) {
    GoRouter.of(context).goToResults();
  }

  static void toDetail(BuildContext context, NumerologyType type) {
    GoRouter.of(context).goToDetail(type);
  }

  static void toError(BuildContext context, String error) {
    GoRouter.of(context).goToError(error);
  }

  static void back(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).goToWelcome();
    }
  }
}