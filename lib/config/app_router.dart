import 'package:flutter/material.dart';
import '../models/numerology_result.dart';
import '../views/screens/welcome_screen.dart';
import '../views/screens/result_overview_screen.dart';
import '../views/screens/detail_screen.dart';
import '../views/screens/loading_screen.dart';
import '../views/screens/error_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String loading = '/loading';
  static const String results = '/results';
  static const String detail = '/detail';
  static const String error = '/error';
}

class AppNavigator {
  static void toWelcome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  static void toLoading(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LoadingScreen()));
  }

  static void toResults(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ResultOverviewScreen()));
  }

  static void toDetail(BuildContext context, NumerologyType type) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DetailScreen(type: type)));
  }

  static void toError(BuildContext context, String error) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ErrorScreen(error: error)));
  }

  static void back(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      toWelcome(context);
    }
  }
}
