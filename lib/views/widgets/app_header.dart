import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Icon/Logo
        Container(
          width: ResponsiveUtils.responsiveValue(
            context: context,
            mobile: 80.0,
            tablet: 100.0,
            desktop: 120.0,
          ),
          height: ResponsiveUtils.responsiveValue(
            context: context,
            mobile: 80.0,
            tablet: 100.0,
            desktop: 120.0,
          ),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
        ),

        SizedBox(
          height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),

        // Title
        Text(
          'Numero Uno',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: 32.0,
              tablet: 36.0,
              desktop: 40.0,
            ),
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = AppTheme.primaryGradient.createShader(
                const Rect.fromLTWH(0, 0, 200, 70),
              ),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(
          height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12),
        ),

        // Subtitle
        Text(
          'Discover the mystical power of numbers\nand unlock your destiny',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textLight,
            fontSize: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: 16.0,
              tablet: 18.0,
              desktop: 20.0,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
