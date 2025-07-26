// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/gradient_button.dart';
import '../widgets/theme_toggle_fab.dart';
import '../widgets/app_footer.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(context),
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error Icon
                    _buildErrorIcon(context)
                        .animate()
                        .fadeIn(duration: AppTheme.mediumAnimation)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                        ),

                    SizedBox(
                      height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32),
                    ),

                    // Error Title
                    _buildErrorTitle(context)
                        .animate()
                        .fadeIn(duration: AppTheme.mediumAnimation, delay: 200.ms)
                        .slideY(begin: 0.3, end: 0),

                    SizedBox(
                      height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
                    ),

                    // Error Message
                    _buildErrorMessage(context)
                        .animate()
                        .fadeIn(duration: AppTheme.mediumAnimation, delay: 400.ms)
                        .slideY(begin: 0.3, end: 0),

                    SizedBox(
                      height: ResponsiveUtils.getSpacing(context, AppTheme.spacing48),
                    ),

                    // Action Buttons
                    _buildActionButtons(context)
                        .animate()
                        .fadeIn(duration: AppTheme.mediumAnimation, delay: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),

              // Footer
              const AppFooter(),
            ],
          ),
        ),
      ),
      floatingActionButton: const ThemeToggleFAB(),
    );
  }

  Widget _buildErrorIcon(BuildContext context) {
    return Container(
          width: ResponsiveUtils.responsiveValue(
            context: context,
            mobile: 120.0,
            tablet: 140.0,
            desktop: 160.0,
          ),
          height: ResponsiveUtils.responsiveValue(
            context: context,
            mobile: 120.0,
            tablet: 140.0,
            desktop: 160.0,
          ),
          decoration: BoxDecoration(
            color: AppTheme.errorRed.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.errorRed.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.error_outline,
            size: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: 60.0,
              tablet: 70.0,
              desktop: 80.0,
            ),
            color: AppTheme.errorRed,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 2000.ms, color: AppTheme.errorRed.withOpacity(0.3));
  }

  Widget _buildErrorTitle(BuildContext context) {
    return Text(
      'Oops! Something went wrong',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontSize: ResponsiveUtils.responsiveValue(
          context: context,
          mobile: 24.0,
          tablet: 28.0,
          desktop: 32.0,
        ),
        fontWeight: FontWeight.bold,
        color: AppTheme.textDark,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error Details Header
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing8),
                Text(
                  'Error Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12),
            ),

            // Error Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.errorRed.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textDark,
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
            ),

            // Helpful Message
            Text(
              'Don\'t worry! This is usually a temporary issue. Please try again, and if the problem persists, check your internet connection.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textLight,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Try Again Button
        GradientButton(
          onPressed: () => AppNavigator.toWelcome(context),
          text: 'Try Again',
          icon: Icons.refresh,
        ),

        SizedBox(
          height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
        ),

        // Go Home Button
        OutlinedGradientButton(
          onPressed: () => AppNavigator.toWelcome(context),
          text: 'Go to Home',
          icon: Icons.home,
        ),
      ],
    );
  }
}

// Network Error Screen
class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ResponsiveContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Network Icon
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.textLight.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.wifi_off,
                      size: 60,
                      color: AppTheme.textLight,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: AppTheme.spacing32),

              // Title
              Text(
                    'No Internet Connection',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: AppTheme.spacing16),

              // Message
              Text(
                    'Please check your internet connection and try again.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.textLight),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: AppTheme.spacing48),

              // Retry Button
              GradientButton(
                    onPressed: () => AppNavigator.toWelcome(context),
                    text: 'Retry',
                    icon: Icons.refresh,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

// Not Found Screen
class NotFoundScreen extends StatelessWidget {
  final String? path;

  const NotFoundScreen({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ResponsiveContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 404 Icon
              Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '404',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: AppTheme.spacing32),

              // Title
              Text(
                    'Page Not Found',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: AppTheme.spacing16),

              // Message
              Text(
                    path != null
                        ? 'The page "$path" could not be found.'
                        : 'The page you\'re looking for doesn\'t exist.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.textLight),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0),

              const SizedBox(height: AppTheme.spacing48),

              // Go Home Button
              GradientButton(
                    onPressed: () => AppNavigator.toWelcome(context),
                    text: 'Go Home',
                    icon: Icons.home,
                  )
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
