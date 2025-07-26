import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/app_providers.dart';

class ThemeToggleFAB extends ConsumerWidget {
  const ThemeToggleFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return FloatingActionButton(
      onPressed: themeNotifier.toggleTheme,
      tooltip: 'Switch to ${_getNextThemeLabel(themeMode)}',
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          themeNotifier.themeIcon,
          key: ValueKey(themeMode),
          size: 24,
        ),
      ),
    );
  }

  String _getNextThemeLabel(ThemeMode currentMode) {
    switch (currentMode) {
      case ThemeMode.system:
        return 'Light Mode';
      case ThemeMode.light:
        return 'Dark Mode';
      case ThemeMode.dark:
        return 'Auto Mode';
    }
  }
}
