// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'result_overview_platform.dart';

import '../../config/app_router.dart';
import '../../config/app_theme.dart';
import '../../models/numerology_result.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
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
    final result = appState.numerologyResult;

    if (result == null) {
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
            icon: const Icon(Icons.share),
            onPressed: () =>
                _shareResults(context, result, screenshotController),
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

                        // Numbers Grid
                        _buildNumbersGrid(context, result)
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
  Widget _buildNumbersGrid(BuildContext context, NumerologyResult result) {
    final numerologyTypes = NumerologyType.values;

    return ResponsiveUtils.responsiveBuilder(
      context: context,
      mobile: _buildMobileGrid(context, result, numerologyTypes),
      tablet: _buildTabletGrid(context, result, numerologyTypes),
      desktop: _buildDesktopGrid(context, result, numerologyTypes),
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
  ) async {
    final text =
        '''
My Numerology Results - ${result.fullName}

🔮 Life Path Number: ${result.lifePathNumber}
🎂 Birthday Number: ${result.birthdayNumber}
✨ Expression Number: ${result.expressionNumber}
💫 Soul Urge Number: ${result.soulUrgeNumber}
🌟 Personality Number: ${result.personalityNumber}

Driver Number: ${result.driverNumber} (${result.planetaryRuler})
Destiny Number: ${result.destinyNumber}
Personal Year: ${result.personalYear}, Month: ${result.personalMonth}, Day: ${result.personalDay}

${result.driverDestinyMeaning}

Loshu Grid: ${result.loshuGrid}
Missing Numbers: ${result.missingNumbers.join(", ")}
Magical Numbers: ${result.magicalNumbers.join(", ")}

Name Compatibility: ${result.nameCompatibility['recommendation']}

Calculated with Numero Uno - Discover your mystical numbers!
Visit https://awes0m.github.io/numero_uno to explore your own mystical numbers!
''';

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
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
                  await downloadImageMobile(image, context);
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

  /// Enhanced numerology features section
  Widget _buildEnhancedFeatures(BuildContext context, NumerologyResult result) {
    final remedies = result.getRemedies();
    final loshuGridStr = result.getLoshuGridFormatted();
    final isFavorable =
        [1, 3, 5, 6, 7].contains(result.personalYear) ||
        [1, 3, 5, 6, 7].contains(result.personalMonth) ||
        [1, 3, 5, 6, 7].contains(result.personalDay);

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
                Text(
                  loshuGridStr,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
                ),
                if (result.magicalNumbers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Magical Numbers: ${result.magicalNumbers.join(", ")}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                if (result.missingNumbers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Missing Numbers: ${result.missingNumbers.join(", ")}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.red),
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
                Text(
                  'First Name with Driver: ${result.nameCompatibility['firstNameWithDriver']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'First Name with Destiny: ${result.nameCompatibility['firstNameWithDestiny']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Full Name with Driver: ${result.nameCompatibility['fullNameWithDriver']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Full Name with Destiny: ${result.nameCompatibility['fullNameWithDestiny']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Recommendation: ${result.nameCompatibility['recommendation']}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppTheme.spacing24),
        // Driver/Destiny Combination & Planetary Ruler
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
                      Icons.auto_fix_high,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Driver/Destiny & Planetary',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),
                Text(
                  'Driver Number: ${result.driverNumber} (${result.planetaryRuler})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Destiny Number: ${result.destinyNumber}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Combination Meaning: ${result.driverDestinyMeaning}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppTheme.spacing24),
        // Personal Year/Month/Day
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
                      'Personal Year/Month/Day',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),
                Text(
                  'Personal Year: ${result.personalYear}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Personal Month: ${result.personalMonth}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Personal Day: ${result.personalDay}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (isFavorable)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '🌟 This is a favorable period for you!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppTheme.spacing24),
        // Remedies & Recommendations
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
                      Icons.healing,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Text(
                      'Remedies & Recommendations',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing16),
                ...remedies.map(
                  (rem) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      rem,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
