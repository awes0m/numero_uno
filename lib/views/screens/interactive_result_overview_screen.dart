// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

import '../../models/numerology_type.dart';
import '../../services/ai_share_service.dart';
import '../../config/app_router.dart';
import '../../config/app_theme.dart';
import '../../models/numerology_result.dart';
import '../../models/dual_numerology_result.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/ai_share_widget.dart';
import '../widgets/app_footer.dart';
import '../widgets/gradient_button.dart';
import '../widgets/numerology_card.dart';
import '../widgets/theme_toggle_fab.dart';
import '../widgets/life_periods_section.dart';

class InteractiveResultOverviewScreen extends HookConsumerWidget {
  const InteractiveResultOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotController = useMemoized(() => ScreenshotController());
    final tabController = useTabController(initialLength: 5);
    final appState = ref.watch(appStateProvider);
    final dualResult = appState.dualNumerologyResult;
    final result = appState.numerologyResult;

    if (dualResult == null || result == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNavigator.toWelcome(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            tooltip: 'Classic View',
            icon: const Icon(Icons.view_day_outlined),
            onPressed: () => AppNavigator.toResultsClassic(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(
              context,
              result,
              screenshotController,
              dualResult,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.star, size: 20), text: 'Core Numbers'),
                Tab(icon: Icon(Icons.auto_awesome, size: 20), text: 'Advanced'),
                Tab(
                  icon: Icon(Icons.timeline, size: 20),
                  text: 'Life Analysis',
                ),
                Tab(icon: Icon(Icons.grid_3x3, size: 20), text: 'Mystical'),
                Tab(icon: Icon(Icons.insights, size: 20), text: 'Insights'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(context),
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            children: [
              // Header Section (always visible)
              _buildHeader(context, result)
                  .animate()
                  .fadeIn(duration: AppTheme.mediumAnimation)
                  .slideY(begin: -0.3, end: 0),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _buildCoreNumbersTab(context, result, dualResult),
                    _buildAdvancedNumbersTab(context, result, dualResult),
                    _buildLifeAnalysisTab(context, result),
                    _buildMysticalFeaturesTab(context, result),
                    _buildInsightsTab(
                      context,
                      result,
                      dualResult,
                      screenshotController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const ThemeToggleFAB(),
    );
  }

  /// Header section with user's name and birth date (compact version)
  Widget _buildHeader(BuildContext context, NumerologyResult result) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacing16),
      child: Card(
        child: Container(
          decoration: AppTheme.getCardDecoration(context),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: Row(
            children: [
              // Mystical Icon
              Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 3000.ms,
                    color: Colors.white.withOpacity(0.3),
                  ),

              const SizedBox(width: AppTheme.spacing16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.fullName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = AppTheme.primaryGradient.createShader(
                            const Rect.fromLTWH(0, 0, 200, 30),
                          ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      'Born ${dateFormat.format(result.dateOfBirth)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Stats
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing12,
                  vertical: AppTheme.spacing8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightPurple.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: Column(
                  children: [
                    Text(
                      'Life Path',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      result.lifePathNumber.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Core Numbers Tab - Main 5 numerology numbers
  Widget _buildCoreNumbersTab(
    BuildContext context,
    NumerologyResult result,
    DualNumerologyResult dualResult,
  ) {
    final coreTypes = [
      NumerologyType.lifePathNumber,
      NumerologyType.birthdayNumber,
      NumerologyType.expressionNumber,
      NumerologyType.soulUrgeNumber,
      NumerologyType.personalityNumber,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            context,
            'Core Numbers',
            'The fundamental numbers that shape your personality and life path',
            Icons.star,
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Numbers Grid
          ResponsiveUtils.responsiveBuilder(
            context: context,
            mobile: _buildMobileGrid(context, result, coreTypes),
            tablet: _buildTabletGrid(context, result, coreTypes),
            desktop: _buildDesktopGrid(context, result, coreTypes),
          ),

          const SizedBox(height: AppTheme.spacing32),

          // System Comparison (if available)
          if (dualResult.hasBothResults)
            _buildSystemComparison(context, dualResult, coreTypes),
        ],
      ),
    );
  }

  /// Advanced Numbers Tab - Additional numerology numbers
  Widget _buildAdvancedNumbersTab(
    BuildContext context,
    NumerologyResult result,
    DualNumerologyResult dualResult,
  ) {
    final advancedTypes = [
      NumerologyType.driverNumber,
      NumerologyType.destinyNumber,
      NumerologyType.firstNameNumber,
      NumerologyType.fullNameNumber,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            context,
            'Advanced Numbers',
            'Deeper insights into your spiritual journey and name energy',
            Icons.auto_awesome,
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Numbers Grid
          ResponsiveUtils.responsiveBuilder(
            context: context,
            mobile: _buildMobileGrid(context, result, advancedTypes),
            tablet: _buildTabletGrid(context, result, advancedTypes),
            desktop: _buildDesktopGrid(context, result, advancedTypes),
          ),

          const SizedBox(height: AppTheme.spacing32),

          // Name Compatibility Analysis
          _buildNameCompatibilityCard(context, result),
        ],
      ),
    );
  }

  /// Life Analysis Tab - Pinnacles, Challenges, Personal Years
  Widget _buildLifeAnalysisTab(BuildContext context, NumerologyResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            context,
            'Life Analysis',
            'Your life cycles, challenges, and opportunities through time',
            Icons.timeline,
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Pinnacles & Challenges
          _buildPinnaclesAndChallenges(context, result),

          const SizedBox(height: AppTheme.spacing24),

          // Personal Years & Essences
          _buildPersonalYearsAndEssences(context, result),
        ],
      ),
    );
  }

  /// Mystical Features Tab - Loshu Grid, Karmic Lessons, etc.
  Widget _buildMysticalFeaturesTab(
    BuildContext context,
    NumerologyResult result,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            context,
            'Mystical Features',
            'Ancient wisdom and spiritual insights from your numbers',
            Icons.grid_3x3,
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Loshu Grid
          _buildLoshuGridCard(context, result),

          const SizedBox(height: AppTheme.spacing24),

          // Karmic Lessons & Debts
          _buildKarmicLessonsCard(context, result),

          const SizedBox(height: AppTheme.spacing24),

          // Hidden Passion Number
          _buildHiddenPassionCard(context, result),
        ],
      ),
    );
  }

  /// Insights Tab - AI Share and additional insights
  Widget _buildInsightsTab(
    BuildContext context,
    NumerologyResult result,
    DualNumerologyResult dualResult,
    ScreenshotController screenshotController,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            context,
            'Insights & Sharing',
            'Get deeper insights and share your numerology results',
            Icons.insights,
          ),

          const SizedBox(height: AppTheme.spacing24),

          // AI Share Widget
          Card(
            child: AiShareWidget(result: result, dualResult: dualResult),
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Action Buttons
          _buildActionButtons(context),

          const SizedBox(height: AppTheme.spacing24),

          // Calculation System
          Card(
            child: Container(
              decoration: AppTheme.getCardDecoration(context),
              padding: const EdgeInsets.all(AppTheme.spacing24),
              child: Row(
                children: [
                  Icon(Icons.settings, color: AppTheme.primaryPurple, size: 24),
                  const SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calculation System: ${result.systemUsed}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          result.systemUsed == 'Pythagorean'
                              ? 'Modern Western numerology system based on Greek mathematician Pythagoras'
                              : 'Ancient Babylonian system with deeper spiritual meanings',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacing24),

          // Analysis Summary
          if ((result.detailedAnalysis['summary'] ?? '').toString().isNotEmpty)
            Card(
              child: Container(
                decoration: AppTheme.getCardDecoration(context),
                padding: const EdgeInsets.all(AppTheme.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: AppTheme.primaryPurple,
                          size: 24,
                        ),
                        const SizedBox(width: AppTheme.spacing12),
                        Text(
                          'Analysis Summary',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing12),
                    Text(
                      result.detailedAnalysis['summary'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: AppTheme.spacing24),

          // App Footer
          const AppFooter(),
        ],
      ),
    );
  }

  /// Section header with title, description, and icon
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompatibilityLabel(String key) {
    switch (key) {
      case 'lifePath':
        return 'Life Path';
      case 'expression':
        return 'Expression';
      case 'soulUrge':
        return 'Soul Urge';
      case 'personality':
        return 'Personality';
      default:
        return key.split(RegExp(r'(?=[A-Z])')).join(' ');
    }
  }

  /// Mobile layout for the numbers grid
  Widget _buildMobileGrid(
    BuildContext context,
    NumerologyResult result,
    List<NumerologyType> types,
  ) {
    return Column(
      children: types.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        final number = type.getValue(result);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
          child:
              Semantics(
                label: 'Numerology ${type.displayName} number $number',
                child: NumerologyCard(
                  type: type,
                  number: number,
                  onTap: () => AppNavigator.toDetail(context, type),
                ),
              )
                  .animate(delay: (index * 100).ms)
                  .fadeIn(duration: AppTheme.shortAnimation)
                  .slideX(begin: 0.3, end: 0),
        );
      }).toList(),
    );
  }

  /// Tablet layout for the numbers grid
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

  /// Desktop layout for the numbers grid
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
        childAspectRatio: 2,
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

  /// System comparison widget for when both systems are calculated
  Widget _buildSystemComparison(
    BuildContext context,
    DualNumerologyResult dualResult,
    List<NumerologyType> types,
  ) {
    final pythagorean = dualResult.pythagoreanResult;
    final chaldean = dualResult.chaldeanResult;

    if (pythagorean == null || chaldean == null) return const SizedBox.shrink();

    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'System Comparison',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Comparison Table
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightPurple.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Column(
                children: [
                  // Header Row
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPurple.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppTheme.radiusSmall),
                        topRight: Radius.circular(AppTheme.radiusSmall),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Number Type',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Pythagorean',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Chaldean',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data Rows
                  ...types.asMap().entries.map((entry) {
                    final index = entry.key;
                    final type = entry.value;
                    final isLast = index == types.length - 1;

                    return _buildComparisonRow(
                      context,
                      type.displayName,
                      type.getValue(pythagorean),
                      type.getValue(chaldean),
                      isLast: isLast,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Info Text
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppTheme.lightPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: AppTheme.lightPurple.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      'Different numerology systems can provide varying insights. Compare the numbers to see how each system interprets your energy.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context,
    String label,
    int pythagoreanValue,
    int chaldeanValue, {
    bool isLast = false,
  }) {
    final isDifferent = pythagoreanValue != chaldeanValue;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppTheme.lightPurple.withOpacity(0.2),
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: isDifferent
                    ? AppTheme.primaryPurple.withOpacity(0.1)
                    : AppTheme.lightPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: isDifferent
                    ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                pythagoreanValue.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDifferent ? AppTheme.primaryPurple : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing8,
                vertical: AppTheme.spacing4,
              ),
              decoration: BoxDecoration(
                color: isDifferent
                    ? AppTheme.primaryPurple.withOpacity(0.1)
                    : AppTheme.lightPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: isDifferent
                    ? Border.all(color: AppTheme.primaryPurple.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                chaldeanValue.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDifferent ? AppTheme.primaryPurple : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Name Compatibility Analysis Card
  Widget _buildNameCompatibilityCard(
    BuildContext context,
    NumerologyResult result,
  ) {
    final compatibility = result.nameCompatibility;

    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Name Compatibility Analysis',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            if (compatibility.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Text(
                        'Name compatibility analysis is available for detailed insights into how your name aligns with your numerological profile.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (compatibility.containsKey('overallScore')) ...[
              // New detailed format
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${compatibility['overallScore'] ?? 0}%',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Compatibility',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacing4),
                          Text(
                            'Rating: ${compatibility['rating'] ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing12),

              if ((compatibility['details'] ?? {}).isNotEmpty)
                Wrap(
                  spacing: AppTheme.spacing8,
                  runSpacing: AppTheme.spacing8,
                  children: (compatibility['details'] as Map<String, dynamic>)
                      .entries
                      .map((e) {
                        final label = e.key;
                        final score = (e.value['score'] ?? 0) as int;
                        final comment = (e.value['comment'] ?? '') as String;
                        final color = score >= 80
                            ? Colors.green
                            : score >= 65
                            ? Colors.blue
                            : score >= 50
                            ? Colors.orange
                            : Colors.red;
                        return Container(
                          padding: const EdgeInsets.all(AppTheme.spacing12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSmall,
                            ),
                            border: Border.all(color: color.withOpacity(0.25)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _formatCompatibilityLabel(label),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacing8,
                                      vertical: AppTheme.spacing4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSmall,
                                      ),
                                    ),
                                    child: Text(
                                      '$score%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              if (comment.isNotEmpty) ...[
                                const SizedBox(height: AppTheme.spacing8),
                                Text(
                                  comment,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        );
                      })
                      .toList(),
                ),

              if ((compatibility['recommendations'] ?? []).isNotEmpty) ...[
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  'Recommendations',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppTheme.spacing8),
                ...List<Widget>.from(
                  (compatibility['recommendations'] as List).map(
                    (r) => Container(
                      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                      padding: const EdgeInsets.all(AppTheme.spacing12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              r.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ] else ...[
              // Legacy simple format
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: AppTheme.lightPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: AppTheme.lightPurple.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      compatibility['recommendation']?.toString() ??
                          'Analysis available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Pinnacles and Challenges Card
  Widget _buildPinnaclesAndChallenges(
    BuildContext context,
    NumerologyResult result,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Pinnacles & Challenges',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Pinnacles
            _buildLifePeriodsSection(
              context,
              'Pinnacles',
              result.pinnacles,
              Icons.trending_up,
              AppTheme.primaryPurple,
              isPinnacles: true,
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Challenges
            _buildLifePeriodsSection(
              context,
              'Challenges',
              result.challenges,
              Icons.trending_down,
              Colors.orange,
              isChallenges: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Personal Years and Essences Card
  Widget _buildPersonalYearsAndEssences(
    BuildContext context,
    NumerologyResult result,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Personal Years & Essences',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Personal Years
            if (result.personalYears.isNotEmpty) ...[
              LifePeriodsSection(
                title: 'Personal Years',
                periods: result.personalYears,
                icon: Icons.calendar_month,
                color: Colors.green,
                showMeanings: true,
                enableYearNavigator: true,
                initialExpanded: true,
              ),

              const SizedBox(height: AppTheme.spacing16),
            ],

            // Essences
            LifePeriodsSection(
              title: 'Essences',
              periods: result.essences,
              icon: Icons.auto_awesome,
              color: Colors.purple,
              showMeanings: true,
              enableYearNavigator: true,
              initialExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  /// Loshu Grid Card
  Widget _buildLoshuGridCard(BuildContext context, NumerologyResult result) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_3x3, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Loshu Grid & Numbers',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Grid Visualization
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.lightPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: AppTheme.lightPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Birth Date Number Distribution',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppTheme.spacing12),

                  // Grid Display
                  _buildLoshuGridDisplay(context, result.loshuGrid),

                  const SizedBox(height: AppTheme.spacing12),

                  // Numbers Summary
                  if (result.magicalNumbers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.primaryPurple,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              'Magical Numbers: ${result.magicalNumbers.join(", ")}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (result.missingNumbers.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: AppTheme.spacing8),
                      padding: const EdgeInsets.all(AppTheme.spacing8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: AppTheme.spacing8),
                          Expanded(
                            child: Text(
                              'Missing Numbers: ${result.missingNumbers.join(", ")}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange.shade700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hidden Passion Card
  Widget _buildHiddenPassionCard(
    BuildContext context,
    NumerologyResult result,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Hidden Passion Number',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        result.hiddenPassionNumber.toString(),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing16),
                  Expanded(
                    child: Text(
                      'This number reveals your deepest desires and what truly motivates you in life.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Karmic Lessons Card
  Widget _buildKarmicLessonsCard(
    BuildContext context,
    NumerologyResult result,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Text(
                  'Karmic Lessons & Debts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing16),

            // Karmic Lessons
            if (result.karmicLessons.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school, size: 20, color: Colors.blue),
                        const SizedBox(width: AppTheme.spacing8),
                        Text(
                          'Karmic Lessons to Learn',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Numbers ${result.karmicLessons.join(", ")} represent areas where you need to develop and grow spiritually.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: AppTheme.spacing8),
                    ...result.karmicLessons.map((number) {
                      final meaning = _getKarmicLessonMeaning(number);
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                        padding: const EdgeInsets.all(AppTheme.spacing12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  number.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacing12),
                            Expanded(
                              child: Text(
                                meaning,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacing16),
            ],

            // Karmic Debts
            if (result.karmicDebts.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Text(
                          'Karmic Debts to Resolve',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(
                      'Numbers ${result.karmicDebts.join(", ")} indicate karmic debts from past lives that need attention.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20, color: Colors.green),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Text(
                        'No karmic debts detected - you have a clean karmic slate!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Action buttons for recalculating and getting more info
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

        const SizedBox(height: AppTheme.spacing16),

        // Info Text
        Text(
          'Tap on any number card to learn more about its meaning and significance in your life.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Share numerology results as text or image
  Future<void> _shareResults(
    BuildContext context,
    NumerologyResult result,
    ScreenshotController screenshotController,
    DualNumerologyResult? dualResult,
  ) async {
    final text =
        '''
My Numerology Results - ${result.fullName}

🔮 Life Path Number: ${result.lifePathNumber}
🎂 Birthday Number: ${result.birthdayNumber}
✨ Expression Number: ${result.expressionNumber}
💫 Soul Urge Number: ${result.soulUrgeNumber}
🌟 Personality Number: ${result.personalityNumber}

Driver Number: ${result.driverNumber}
Destiny Number: ${result.destinyNumber}

Loshu Grid: ${result.loshuGrid}
Missing Numbers: ${result.missingNumbers.join(", ")}
Magical Numbers: ${result.magicalNumbers.join(", ")}

Name Compatibility: ${result.nameCompatibility['recommendation'] ?? 'Analysis available'}

Calculated with Numero Uno - Discover your mystical numbers!
Visit https://awes0m.github.io/numero_uno to explore your own mystical numbers!
''';

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('Share to AI Assistant'),
              subtitle: const Text(
                'Get deeper insights from ChatGPT, Claude, etc.',
              ),
              onTap: () async {
                final aiPrompt = AiShareService.generateAiPrompt(
                  result,
                  dualResult,
                );
                await Clipboard.setData(ClipboardData(text: aiPrompt));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'AI prompt copied! Paste it into any AI assistant for detailed analysis.',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet),
              title: const Text('Share as Text'),
              onTap: () async {
                await Share.share(text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Share as Image'),
              onTap: () async {
                final image = await screenshotController.capture();
                if (image != null) {
                  await Share.shareXFiles(
                    [
                      XFile.fromData(
                        image,
                        name: 'numerology_result.png',
                        mimeType: 'image/png',
                      ),
                    ],
                    text:
                        'My Numerology Results!\nVisit https://awes0m.github.io/numero_uno to explore your own mystical numbers!',
                  );
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download as Image'),
              onTap: () async {
                final image = await screenshotController.capture();
                if (image != null) {
                  await _downloadImageMobile(image, context);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImageMobile(
    Uint8List image,
    BuildContext context,
  ) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Image captured successfully! Use share option to save.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper methods that need to be implemented based on the original file
  Widget _buildLifePeriodsSection(
    BuildContext context,
    String title,
    Map<String, int> data,
    IconData icon,
    Color color, {
    bool isPinnacles = false,
    bool isChallenges = false,
  }) {
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                'No $title data available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color.withOpacity(0.8),
                    ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing8),
          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children: data.entries.map((entry) {
              final periodKey = entry.key;
              final number = entry.value;
              final periodInfo = _getPeriodInfo(
                periodKey,
                number,
                isPinnacles,
                isChallenges,
              );
              final showPersonalYearMeaning = title == 'Personal Years';
              final meaning = isPinnacles || isChallenges
                  ? periodInfo['meaning']
                  : (showPersonalYearMeaning
                      ? _getPersonalYearMeaning(number)
                      : null);

              return Container(
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      periodInfo['label'] ?? periodKey.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      number.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    if (meaning != null && meaning.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        meaning,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: color.withOpacity(0.8),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoshuGridDisplay(BuildContext context, Map<int, int> loshuGrid) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.lightPurple.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final number = index + 1;
              final count = loshuGrid[number] ?? 0;
              final hasNumber = count > 0;

              return Semantics(
                label: hasNumber
                    ? 'Loshu cell $number count $count'
                    : 'Loshu cell $number missing',
                child: Container(
                  decoration: BoxDecoration(
                    color: hasNumber
                        ? AppTheme.primaryPurple.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: hasNumber
                          ? AppTheme.primaryPurple.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          number.toString(),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: hasNumber
                                    ? AppTheme.primaryPurple
                                    : Colors.grey,
                              ),
                        ),
                        if (hasNumber)
                          Text(
                            '($count)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.primaryPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getPinnacleMeaning(int number) {
    switch (number) {
      case 1:
        return 'Leadership and independence';
      case 2:
        return 'Partnership and cooperation';
      case 3:
        return 'Creativity and expression';
      case 4:
        return 'Stability and foundation';
      case 5:
        return 'Adventure and change';
      case 6:
        return 'Harmony and responsibility';
      case 7:
        return 'Spiritual growth and wisdom';
      case 8:
        return 'Material success and power';
      case 9:
        return 'Completion and compassion';
      case 11:
        return 'Spiritual inspiration';
      case 22:
        return 'Master building';
      case 33:
        return 'Master healing';
      default:
        return 'Unique pinnacle energy';
    }
  }

  String _getChallengeMeaning(int number) {
    switch (number) {
      case 1:
        return 'Overcoming self-doubt';
      case 2:
        return 'Building confidence';
      case 3:
        return 'Finding focus and discipline';
      case 4:
        return 'Embracing change';
      case 5:
        return 'Finding stability';
      case 6:
        return 'Balancing responsibilities';
      case 7:
        return 'Trusting intuition';
      case 8:
        return 'Developing patience';
      case 9:
        return 'Letting go of the past';
      case 11:
        return 'Managing sensitivity';
      case 22:
        return 'Balancing vision with practicality';
      case 33:
        return 'Channeling healing energy';
      default:
        return 'Unique challenge to overcome';
    }
  }

  Map<String, String> _getPeriodInfo(
    String key,
    int number,
    bool isPinnacles,
    bool isChallenges,
  ) {
    final Map<String, String> info = {};

    if (isPinnacles) {
      switch (key) {
        case 'p1':
          info['label'] = 'First Pinnacle';
          info['meaning'] = _getPinnacleMeaning(number);
          break;
        case 'p2':
          info['label'] = 'Second Pinnacle';
          info['meaning'] = _getPinnacleMeaning(number);
          break;
        case 'p3':
          info['label'] = 'Third Pinnacle';
          info['meaning'] = _getPinnacleMeaning(number);
          break;
        case 'p4':
          info['label'] = 'Fourth Pinnacle';
          info['meaning'] = _getPinnacleMeaning(number);
          break;
        default:
          info['label'] = key.toUpperCase();
      }
    } else if (isChallenges) {
      switch (key) {
        case 'c1':
          info['label'] = 'First Challenge';
          info['meaning'] = _getChallengeMeaning(number);
          break;
        case 'c2':
          info['label'] = 'Second Challenge';
          info['meaning'] = _getChallengeMeaning(number);
          break;
        case 'c3':
          info['label'] = 'Third Challenge';
          info['meaning'] = _getChallengeMeaning(number);
          break;
        case 'c4':
          info['label'] = 'Fourth Challenge';
          info['meaning'] = _getChallengeMeaning(number);
          break;
        default:
          info['label'] = key.toUpperCase();
      }
    } else {
      info['label'] = key.toUpperCase();
    }

    return info;
  }

  String _getPersonalYearMeaning(int number) {
    switch (number) {
      case 1:
        return 'New beginnings';
      case 2:
        return 'Partnerships';
      case 3:
        return 'Creativity';
      case 4:
        return 'Stability';
      case 5:
        return 'Adventure';
      case 6:
        return 'Harmony';
      case 7:
        return 'Introspection';
      case 8:
        return 'Power';
      case 9:
        return 'Completion';
      default:
        return 'Unknown';
    }
  }

  String _getKarmicLessonMeaning(int number) {
    switch (number) {
      case 1:
        return 'Learn independence and leadership';
      case 2:
        return 'Develop cooperation and trust';
      case 3:
        return 'Express creativity and communication';
      case 4:
        return 'Build discipline and structure';
      case 5:
        return 'Balance freedom with responsibility';
      case 6:
        return 'Nurture and serve others';
      case 7:
        return 'Seek spiritual understanding';
      case 8:
        return 'Master material world';
      case 9:
        return 'Develop universal compassion';
      default:
        return 'No specific lesson';
    }
  }
}

// Extension to scale gradients
extension GradientScale on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
    );
  }
}
