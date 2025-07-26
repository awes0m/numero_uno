import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
        horizontal: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
      ),
      child: InkWell(
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
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
