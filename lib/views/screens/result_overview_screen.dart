// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// Added for Uint8List
import 'package:flutter/services.dart'; // Added for ScaffoldMessenger

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

class ResultOverviewScreen extends HookConsumerWidget {
  const ResultOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshotController = useMemoized(() => ScreenshotController());
    final appState = ref.watch(appStateProvider);
    final dualResult = appState.dualNumerologyResult;
    final result = appState.numerologyResult;

    if (dualResult == null || result == null) {
      // If there's no result, navigate back to the welcome screen
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
            tooltip: 'Interactive View',
            icon: const Icon(Icons.tab_outlined),
            onPressed: () => AppNavigator.toResultsInteractive(context),
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
      ),
      body: Container(
        decoration: AppTheme.getBackgroundDecoration(context),
        child: ResponsiveContainer(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Screenshot(
                    controller: screenshotController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing24,
                          ),
                        ),

                        // Header Section
                        _buildHeader(context, result)
                            .animate()
                            .fadeIn(duration: AppTheme.mediumAnimation)
                            .slideY(begin: -0.3, end: 0),

                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing32,
                          ),
                        ),

                        // System Comparison (if both systems are available)
                        if (dualResult.hasBothResults)
                          _buildSystemComparison(context, dualResult)
                              .animate()
                              .fadeIn(
                                duration: AppTheme.mediumAnimation,
                                delay: 150.ms,
                              )
                              .slideY(begin: 0.3, end: 0),

                        if (dualResult.hasBothResults)
                          SizedBox(
                            height: ResponsiveUtils.getSpacing(
                              context,
                              AppTheme.spacing32,
                            ),
                          ),

                        // Numbers Grid
                        _buildNumbersGrid(context, dualResult, result)
                            .animate()
                            .fadeIn(
                              duration: AppTheme.mediumAnimation,
                              delay: 200.ms,
                            )
                            .slideY(begin: 0.3, end: 0),

                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing32,
                          ),
                        ),

                        // Enhanced Numerology Features
                        _buildEnhancedFeatures(context, result)
                            .animate()
                            .fadeIn(
                              duration: AppTheme.mediumAnimation,
                              delay: 300.ms,
                            )
                            .slideY(begin: 0.3, end: 0),

                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing32,
                          ),
                        ),

                        // AI Share Feature
                        Card(
                              child: AiShareWidget(
                                result: result,
                                dualResult: dualResult,
                              ),
                            )
                            .animate()
                            .fadeIn(
                              duration: AppTheme.mediumAnimation,
                              delay: 350.ms,
                            )
                            .slideY(begin: 0.3, end: 0),

                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing32,
                          ),
                        ),

                        // Action Buttons
                        _buildActionButtons(context)
                            .animate()
                            .fadeIn(
                              duration: AppTheme.mediumAnimation,
                              delay: 400.ms,
                            )
                            .slideY(begin: 0.3, end: 0),

                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context,
                            AppTheme.spacing32,
                          ),
                        ),

                        const AppFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const ThemeToggleFAB(),
    );
  }

  /// Header section with user's name and birth date
  Widget _buildHeader(BuildContext context, NumerologyResult result) {
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
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
                .shimmer(
                  duration: 3000.ms,
                  color: Colors.white.withOpacity(0.3),
                ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),

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

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing8),
            ),

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

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
            ),

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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Grid of numerology numbers
  Widget _buildNumbersGrid(
    BuildContext context,
    DualNumerologyResult dualResult,
    NumerologyResult result,
  ) {
    final numerologyTypes = NumerologyType.values;

    return ResponsiveUtils.responsiveBuilder(
      context: context,
      mobile: _buildMobileGrid(context, result, numerologyTypes),
      tablet: _buildTabletGrid(context, result, numerologyTypes),
      desktop: _buildDesktopGrid(context, result, numerologyTypes),
    );
  }

  /// System comparison widget for when both systems are calculated
  Widget _buildSystemComparison(
    BuildContext context,
    DualNumerologyResult dualResult,
  ) {
    final pythagorean = dualResult.pythagoreanResult;
    final chaldean = dualResult.chaldeanResult;

    if (pythagorean == null || chaldean == null) return const SizedBox.shrink();

    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
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

            SizedBox(height: AppTheme.spacing16),

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
                  _buildComparisonRow(
                    context,
                    'Life Path',
                    pythagorean.lifePathNumber,
                    chaldean.lifePathNumber,
                  ),
                  _buildComparisonRow(
                    context,
                    'Expression',
                    pythagorean.expressionNumber,
                    chaldean.expressionNumber,
                  ),
                  _buildComparisonRow(
                    context,
                    'Soul Urge',
                    pythagorean.soulUrgeNumber,
                    chaldean.soulUrgeNumber,
                  ),
                  _buildComparisonRow(
                    context,
                    'Personality',
                    pythagorean.personalityNumber,
                    chaldean.personalityNumber,
                  ),
                  _buildComparisonRow(
                    context,
                    'Birthday',
                    pythagorean.birthdayNumber,
                    chaldean.birthdayNumber,
                    isLast: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacing16),

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

        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
          child:
              NumerologyCard(
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
        crossAxisCount: 2,
        childAspectRatio: 1.4,
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

        SizedBox(
          height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
        ),

        // Info Text
        Text(
          'Tap on any number card above to learn more about its meaning and significance in your life.',
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

  /// Download image on mobile devices
  Future<void> _downloadImageMobile(
    Uint8List image,
    BuildContext context,
  ) async {
    try {
      // For mobile, we'll show a success message since direct download isn't straightforward
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

  /// Enhanced numerology features section
  Widget _buildEnhancedFeatures(BuildContext context, NumerologyResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Loshu Grid
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.grid_3x3,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Loshu Grid & Numbers',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                // Loshu Grid Visualization
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
                      // Grid Header
                      Text(
                        'Your Birth Date Number Distribution',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppTheme.spacing12),

                      // Grid Display
                      _buildLoshuGridDisplay(context, result.loshuGrid),

                      SizedBox(height: AppTheme.spacing12),

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
        ),

        SizedBox(height: AppTheme.spacing24),

        // Pinnacles & Challenges
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Pinnacles & Challenges',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                // Pinnacles
                _buildLifePeriodsSection(
                  context,
                  'Pinnacles',
                  result.pinnacles,
                  Icons.trending_up,
                  AppTheme.primaryPurple,
                  isPinnacles: true,
                ),

                SizedBox(height: AppTheme.spacing16),

                // Challenges
                _buildLifePeriodsSection(
                  context,
                  'Challenges',
                  result.challenges,
                  Icons.trending_down,
                  Colors.orange,
                  isChallenges: true,
                ),

                SizedBox(height: AppTheme.spacing16),

                // Personal Year Predictions
                if (result.personalYears.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.green,
                            ),
                            const SizedBox(width: AppTheme.spacing8),
                            Text(
                              'Personal Year Predictions',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        Text(
                          'Your personal year numbers indicate the energy and opportunities for each year:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        Wrap(
                          spacing: AppTheme.spacing8,
                          runSpacing: AppTheme.spacing8,
                          children: result.personalYears.entries.map((entry) {
                            final year = entry.key;
                            final number = entry.value;
                            final meaning = _getPersonalYearMeaning(number);

                            return Container(
                              padding: const EdgeInsets.all(AppTheme.spacing12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusSmall,
                                ),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    year,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade700,
                                        ),
                                  ),
                                  SizedBox(height: AppTheme.spacing4),
                                  Text(
                                    number.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade700,
                                        ),
                                  ),
                                  SizedBox(height: AppTheme.spacing4),
                                  Text(
                                    meaning,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.green.shade600,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // Personal Years & Essences
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
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
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                // Personal Years
                _buildLifePeriodsSection(
                  context,
                  'Personal Years',
                  result.personalYears,
                  Icons.calendar_month,
                  AppTheme.primaryPurple,
                ),

                SizedBox(height: AppTheme.spacing16),

                // Essences
                _buildLifePeriodsSection(
                  context,
                  'Essences',
                  result.essences,
                  Icons.auto_awesome,
                  Colors.purple,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // Karmic Lessons & Debts
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Karmic Lessons & Debts',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                // Karmic Lessons
                if (result.karmicLessons.isNotEmpty)
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
                        SizedBox(height: AppTheme.spacing8),
                        Text(
                          'Numbers ${result.karmicLessons.join(", ")} represent areas where you need to develop and grow spiritually.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: AppTheme.spacing8),
                        // Add detailed karmic lesson meanings
                        ...result.karmicLessons.map((number) {
                          final meaning = _getKarmicLessonMeaning(number);
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AppTheme.spacing8,
                            ),
                            padding: const EdgeInsets.all(AppTheme.spacing12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSmall,
                              ),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.2),
                              ),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                if (result.karmicLessons.isEmpty)
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
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: Text(
                            'No major karmic lessons detected. You have a balanced spiritual foundation.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: AppTheme.spacing16),

                // Karmic Debts
                if (result.karmicDebts.isNotEmpty)
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
                            Icon(Icons.gavel, size: 20, color: Colors.red),
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
                        SizedBox(height: AppTheme.spacing8),
                        Text(
                          'Numbers ${result.karmicDebts.join(", ")} indicate past-life debts that need attention in this lifetime.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                if (result.karmicDebts.isEmpty)
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
                        const SizedBox(width: AppTheme.spacing8),
                        Expanded(
                          child: Text(
                            'No karmic debts detected. You have a clean spiritual slate.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // Hidden Passion Number
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Hidden Passion Number',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            result.hiddenPassionNumber.toString(),
                            style: Theme.of(context).textTheme.headlineMedium
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
                              'Your Hidden Passion',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: AppTheme.spacing4),
                            Text(
                              'This number reveals your deepest desires and what truly motivates you in life.',
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
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // Name Compatibility
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: AppTheme.primaryPurple, size: 24),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Name Compatibility',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                _buildNameCompatibilitySection(
                  context,
                  result.nameCompatibility,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // Detailed Analysis
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
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
                      'Detailed Analysis',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                _buildDetailedAnalysisSection(context, result.detailedAnalysis),
              ],
            ),
          ),
        ),

        SizedBox(height: AppTheme.spacing24),

        // System Used
        Card(
          child: Container(
            decoration: AppTheme.getCardDecoration(context),
            padding: EdgeInsets.all(
              ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Calculation System',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),

                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing16),
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
                        Icons.calculate,
                        size: 24,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'System Used: ${result.systemUsed}',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: AppTheme.spacing4),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build Loshu Grid display
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

              return Container(
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
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build life periods section (Pinnacles, Challenges, Personal Years, Essences)
  Widget _buildLifePeriodsSection(
    BuildContext context,
    String title,
    Map<String, int> periods,
    IconData icon,
    Color color, {
    bool isPinnacles = false,
    bool isChallenges = false,
  }) {
    if (periods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              'No $title data available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
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
        SizedBox(height: AppTheme.spacing8),

        Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: periods.entries.map((entry) {
            final periodKey = entry.key;
            final number = entry.value;
            final periodInfo = _getPeriodInfo(
              periodKey,
              number,
              isPinnacles,
              isChallenges,
            );

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
                  SizedBox(height: AppTheme.spacing4),
                  Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (periodInfo['meaning'] != null) ...[
                    SizedBox(height: AppTheme.spacing4),
                    Text(
                      periodInfo['meaning']!,
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
    );
  }

  /// Get period information for pinnacles and challenges
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

  /// Get pinnacle meaning based on number
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

  /// Get challenge meaning based on number
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

  /// Build name compatibility section
  Widget _buildNameCompatibilitySection(
    BuildContext context,
    Map<String, dynamic> compatibility,
  ) {
    if (compatibility.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.grey),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              'Name compatibility data not available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // Handle different compatibility data structures
    if (compatibility.containsKey('recommendation')) {
      // Old format
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.lightPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: AppTheme.lightPurple.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name Compatibility Analysis',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
            SizedBox(height: AppTheme.spacing8),
            Text(
              compatibility['recommendation'] ?? 'Analysis not available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    // New format with detailed compatibility
    final overallScore = compatibility['overallScore'] ?? 0;
    final rating = compatibility['rating'] ?? 'Unknown';
    final details = compatibility['details'] ?? <String, dynamic>{};
    final recommendations = compatibility['recommendations'] ?? <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Score
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            gradient: _getCompatibilityGradient(overallScore),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$overallScore%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4),
                    Text(
                      'Rating: $rating',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppTheme.spacing16),

        // Detailed Scores
        if (details.isNotEmpty) ...[
          Text(
            'Detailed Breakdown',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppTheme.spacing8),

          ...details.entries.map((entry) {
            final score = entry.value['score'] ?? 0;
            // final comment = entry.value['comment'] ?? '';

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: _getScoreColor(score).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: _getScoreColor(score).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      _formatCompatibilityLabel(entry.key),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                      color: _getScoreColor(score).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      '$score%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getScoreColor(score),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: AppTheme.spacing12),

          // Comments
          if (details.isNotEmpty)
            ...details.entries.map((entry) {
              final comment = entry.value['comment'] ?? '';
              if (comment.isEmpty) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                padding: const EdgeInsets.all(AppTheme.spacing12),
                decoration: BoxDecoration(
                  color: AppTheme.lightPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
        ],

        // Recommendations
        if (recommendations.isNotEmpty) ...[
          SizedBox(height: AppTheme.spacing16),

          Text(
            'Recommendations',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppTheme.spacing8),

          ...recommendations
              .map(
                (recommendation) => Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: Text(
                          recommendation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ],
    );
  }

  /// Build detailed analysis section
  Widget _buildDetailedAnalysisSection(
    BuildContext context,
    Map<String, dynamic> analysis,
  ) {
    if (analysis.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Colors.grey),
            const SizedBox(width: AppTheme.spacing8),
            Text(
              'Detailed analysis not available',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        if (analysis['summary'] != null) ...[
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.lightPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(color: AppTheme.lightPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Summary',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  analysis['summary'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
        ],

        // Life Path Analysis
        if (analysis['lifePathAnalysis'] != null) ...[
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    const SizedBox(width: AppTheme.spacing8),
                    Text(
                      'Life Path Analysis',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing8),
                Text(
                  analysis['lifePathAnalysis'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spacing16),
        ],

        // Number Meanings
        if (analysis['meanings'] != null) ...[
          Text(
            'Number Meanings',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppTheme.spacing8),

          ...(analysis['meanings'] as Map<String, dynamic>).entries.map((
            entry,
          ) {
            final meaning = entry.value;
            if (meaning == null || meaning.toString().isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatNumberLabel(entry.key),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing4),
                  Text(meaning, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }),

          SizedBox(height: AppTheme.spacing16),
        ],

        // Karmic Debts Details
        if (analysis['karmicDebts'] != null &&
            (analysis['karmicDebts'] as List).isNotEmpty) ...[
          Text(
            'Karmic Debt Details',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppTheme.spacing8),

          ...(analysis['karmicDebts'] as List).map((debt) {
            final number = debt['number'];
            final meaning = debt['meaning'];
            if (number == null || meaning == null) {
              return const SizedBox.shrink();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Karmic Debt $number',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing4),
                  Text(meaning, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }),

          SizedBox(height: AppTheme.spacing16),
        ],

        // Additional Analysis Data
        ...analysis.entries
            .where(
              (entry) =>
                  ![
                    'summary',
                    'meanings',
                    'karmicDebts',
                    'lifePathAnalysis',
                  ].contains(entry.key) &&
                  entry.value != null &&
                  entry.value.toString().isNotEmpty,
            )
            .map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
                padding: const EdgeInsets.all(AppTheme.spacing12),
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
                      _formatAnalysisLabel(entry.key),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  /// Helper methods for formatting and styling
  LinearGradient _getCompatibilityGradient(int score) {
    if (score >= 80) {
      return LinearGradient(
        colors: [Colors.green.shade400, Colors.green.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (score >= 65) {
      return LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (score >= 50) {
      return LinearGradient(
        colors: [Colors.orange.shade400, Colors.orange.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [Colors.red.shade400, Colors.red.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 65) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
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

  String _formatNumberLabel(String key) {
    switch (key) {
      case 'lifePath':
        return 'Life Path Number';
      case 'birthday':
        return 'Birthday Number';
      case 'expression':
        return 'Expression Number';
      case 'soulUrge':
        return 'Soul Urge Number';
      case 'personality':
        return 'Personality Number';
      default:
        return key.split(RegExp(r'(?=[A-Z])')).join(' ');
    }
  }

  String _formatAnalysisLabel(String key) {
    switch (key) {
      case 'pinnacles':
        return 'Pinnacles Analysis';
      case 'challenges':
        return 'Challenges Analysis';
      case 'loshu':
        return 'Loshu Grid Analysis';
      default:
        return key.split(RegExp(r'(?=[A-Z])')).join(' ');
    }
  }

  String _getKarmicLessonMeaning(int number) {
    switch (number) {
      case 1:
        return 'You have a strong desire to be independent and self-reliant. This number often indicates a need to learn to rely on others and develop a sense of community.';
      case 2:
        return 'You may struggle with feelings of insecurity or fear of abandonment. This number suggests the importance of developing trust and forming strong, supportive relationships.';
      case 3:
        return 'You have a natural inclination towards creativity and expression. This number often indicates a need to learn to be disciplined and focused in order to achieve your goals.';
      case 4:
        return 'You may have a tendency towards perfectionism or a fear of failure. This number suggests the importance of learning to accept imperfection and develop resilience.';
      case 5:
        return 'You have a strong desire for freedom and adventure. This number often indicates a need to learn to be grounded and committed to your responsibilities.';
      case 6:
        return 'You may struggle with feelings of guilt or responsibility. This number suggests the importance of learning to forgive yourself and develop a sense of personal power.';
      case 7:
        return 'You have a natural curiosity and desire for knowledge. This number often indicates a need to learn to be patient and disciplined in order to achieve your goals.';
      case 8:
        return 'You may struggle with feelings of powerlessness or victimhood. This number suggests the importance of learning to assert yourself and develop a sense of personal agency.';
      case 9:
        return 'You have a strong desire for spiritual growth and enlightenment. This number often indicates a need to learn to be compassionate and develop a sense of universal interconnectedness.';
      default:
        return 'No specific meaning found for this number.';
    }
  }

  String _getPersonalYearMeaning(int number) {
    switch (number) {
      case 1:
        return 'A year of new beginnings, opportunities for personal growth, and the ability to take initiative. It\'s a time for setting goals and taking action.';
      case 2:
        return 'A year of partnerships, collaboration, and diplomacy. It\'s a time for building relationships and working together.';
      case 3:
        return 'A year of creativity, communication, and social interactions. It\'s a time for expressing yourself and enjoying life.';
      case 4:
        return 'A year of stability, structure, and practicality. It\'s a time for completing projects and focusing on the details.';
      case 5:
        return 'A year of adventure, change, and freedom. It\'s a time for exploring new opportunities and taking risks.';
      case 6:
        return 'A year of harmony, balance, and emotional well-being. It\'s a time for nurturing relationships and finding peace.';
      case 7:
        return 'A year of introspection, spiritual growth, and intellectual pursuits. It\'s a time for learning and gaining wisdom.';
      case 8:
        return 'A year of power, authority, and material success. It\'s a time for achieving goals and gaining recognition.';
      case 9:
        return 'A year of completion, letting go, and spiritual enlightenment. It\'s a time for reflection and preparing for the next cycle.';
      default:
        return 'No specific meaning found for this personal year number.';
    }
  }
}
