// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../models/numerology_result.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/numerology_card.dart';
import '../widgets/gradient_button.dart';

class ResultOverviewScreen extends ConsumerWidget {
  const ResultOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final result = appState.numerologyResult;

    if (result == null) {
      return const Scaffold(
        body: Center(
          child: Text('No results available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Numerology'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigator.toWelcome(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context, result),
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24)),
                
                // Header Section
                _buildHeader(context, result)
                    .animate()
                    .fadeIn(duration: AppTheme.mediumAnimation)
                    .slideY(begin: -0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
                
                // Numbers Grid
                _buildNumbersGrid(context, result)
                    .animate()
                    .fadeIn(duration: AppTheme.mediumAnimation, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
                
                // Action Buttons
                _buildActionButtons(context)
                    .animate()
                    .fadeIn(duration: AppTheme.mediumAnimation, delay: 400.ms)
                    .slideY(begin: 0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NumerologyResult result) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    
    return Card(
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
        child: Column(
          children: [
            // Mystical Icon
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
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 40,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 3000.ms, color: Colors.white.withOpacity(0.3)),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24)),
            
            // Name
            Text(
              result.fullName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 24.0,
                  tablet: 28.0,
                  desktop: 32.0,
                ),
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = AppTheme.primaryGradient.createShader(
                    const Rect.fromLTWH(0, 0, 300, 50),
                  ),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing8)),
            
            // Birth Date
            Text(
              'Born on ${dateFormat.format(result.dateOfBirth)}',
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
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16)),
            
            // Calculation Date
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing8,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightPurple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Text(
                'Calculated on ${dateFormat.format(result.calculatedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumbersGrid(BuildContext context, NumerologyResult result) {
    final numerologyTypes = NumerologyType.values;
    
    return ResponsiveUtils.responsiveBuilder(
      context: context,
      mobile: _buildMobileGrid(context, result, numerologyTypes),
      tablet: _buildTabletGrid(context, result, numerologyTypes),
      desktop: _buildDesktopGrid(context, result, numerologyTypes),
    );
  }

  Widget _buildMobileGrid(
    BuildContext context,
    NumerologyResult result,
    List<NumerologyType> types,
  ) {
    return Column(
      children: types.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
          child: NumerologyCard(
            type: type,
            number: type.getValue(result),
            onTap: () => AppNavigator.toDetail(context, type),
          )
              .animate(delay: (index * 100).ms)
              .fadeIn(duration: AppTheme.shortAnimation)
              .slideX(begin: 0.3, end: 0),
        );
      }).toList(),
    );
  }

  Widget _buildTabletGrid(
    BuildContext context,
    NumerologyResult result,
    List<NumerologyType> types,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.3,
        crossAxisSpacing: AppTheme.spacing16,
        mainAxisSpacing: AppTheme.spacing16,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return NumerologyCard(
          type: type,
          number: type.getValue(result),
          onTap: () => AppNavigator.toDetail(context, type),
        )
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: AppTheme.shortAnimation)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      },
    );
  }

  Widget _buildDesktopGrid(
    BuildContext context,
    NumerologyResult result,
    List<NumerologyType> types,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppTheme.spacing20,
        mainAxisSpacing: AppTheme.spacing20,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        return NumerologyCard(
          type: type,
          number: type.getValue(result),
          onTap: () => AppNavigator.toDetail(context, type),
        )
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: AppTheme.shortAnimation)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Calculate Again Button
        GradientButton(
          onPressed: () => AppNavigator.toWelcome(context),
          text: 'Calculate Again',
          icon: Icons.refresh,
        ),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16)),
        
        // Info Text
        Text(
          'Tap on any number card above to learn more about its meaning and significance in your life.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _shareResults(BuildContext context, NumerologyResult result) {
    final text = '''
My Numerology Results - ${result.fullName}

🔮 Life Path Number: ${result.lifePathNumber}
🎂 Birthday Number: ${result.birthdayNumber}
✨ Expression Number: ${result.expressionNumber}
💫 Soul Urge Number: ${result.soulUrgeNumber}
🌟 Personality Number: ${result.personalityNumber}

Calculated with Numero Uno - Discover your mystical numbers!
''';

    // In a real app, you would use the share_plus package
    // Share.share(text);
    
    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Results'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}