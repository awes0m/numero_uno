import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';

// Provider for view preference
final viewPreferenceProvider = StateProvider<bool>(
  (ref) => true,
); // true = interactive, false = classic

class ViewToggleWidget extends ConsumerWidget {
  const ViewToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInteractive = ref.watch(viewPreferenceProvider);

    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_module,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  'Results View',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing12),

            // Toggle Switch
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(
                  color: AppTheme.lightPurple.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(viewPreferenceProvider.notifier).state =
                              true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                          vertical: AppTheme.spacing12,
                        ),
                        decoration: BoxDecoration(
                          gradient: isInteractive
                              ? AppTheme.primaryGradient
                              : null,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLarge,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.tab,
                              size: 16,
                              color: isInteractive
                                  ? Colors.white
                                  : AppTheme.textLight,
                            ),
                            const SizedBox(width: AppTheme.spacing4),
                            Text(
                              'Interactive',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isInteractive
                                        ? Colors.white
                                        : AppTheme.textLight,
                                    fontWeight: isInteractive
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(viewPreferenceProvider.notifier).state =
                              false,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16,
                          vertical: AppTheme.spacing12,
                        ),
                        decoration: BoxDecoration(
                          gradient: !isInteractive
                              ? AppTheme.primaryGradient
                              : null,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLarge,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_list,
                              size: 16,
                              color: !isInteractive
                                  ? Colors.white
                                  : AppTheme.textLight,
                            ),
                            const SizedBox(width: AppTheme.spacing4),
                            Text(
                              'Classic',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: !isInteractive
                                        ? Colors.white
                                        : AppTheme.textLight,
                                    fontWeight: !isInteractive
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing8),

            // Description
            Text(
              isInteractive
                  ? '✨ Interactive TabBar view with organized sections'
                  : '📜 Classic scrollable view with all information',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textLight,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated navigation method that respects user preference
class SmartNavigator {
  static void toResults(BuildContext context, WidgetRef ref) {
    final isInteractive = ref.read(viewPreferenceProvider);
    if (isInteractive) {
      AppNavigator.toResults(context);
    } else {
      AppNavigator.toResultsInteractive(context);
    }
  }
}
