import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../services/stats_service.dart';

class AppFooter extends HookConsumerWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsService = StatsService();
    // Increment the viewer count once when this widget is built
    useEffect(() {
      statsService.incrementViewerCount();
      return null;
    }, []);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
        horizontal: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              final uri = Uri.parse('https://awes0m.github.io/');
              if (!await launchUrl(uri)) {
                throw Exception('Could not launch $uri');
              }
            },
            child: Text(
              'Made with ❤️ by awes0m',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 12.0,
                  tablet: 13.0,
                  desktop: 14.0,
                ),
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withAlpha(178),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getSpacing(context, AppTheme.spacing8),
          ),
          InkWell(
            onTap: () async {
              final uri = Uri.parse(
                'https://github.com/awes0m/numero_uno/blob/main/README.md',
              );
              if (!await launchUrl(uri)) {
                throw Exception('Could not launch $uri');
              }
            },
            child: StreamBuilder<int>(
              stream: statsService.viewerCountStream(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                final formattedCount = NumberFormat.decimalPattern().format(
                  count,
                );
                return Text(
                  'Total viewers: $formattedCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ResponsiveUtils.responsiveValue(
                      context: context,
                      mobile: 12.0,
                      tablet: 13.0,
                      desktop: 14.0,
                    ),
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withAlpha(178),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
