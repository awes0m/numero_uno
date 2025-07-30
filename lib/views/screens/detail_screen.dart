import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../config/app_router.dart';
import '../../models/numerology_result.dart';
import '../../providers/app_providers.dart';
import '../../services/numerology_service.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/gradient_button.dart';
import '../widgets/numerology_card.dart';
import '../widgets/theme_toggle_fab.dart';
import '../widgets/app_footer.dart';

class DetailScreen extends ConsumerWidget {
  final NumerologyType type;

  const DetailScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final result = appState.numerologyResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(type.displayName)),
        body: const Center(child: Text('No results available')),
      );
    }

    final number = type.getValue(result);
    final detailedDescription = NumerologyService.getDetailedDescription(
      type,
      number,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(type.displayName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigator.back(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareNumber(context, type, number),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing24,
                        ),
                      ),

                      // Hero Number Display
                      _buildHeroNumber(context, number)
                          .animate()
                          .fadeIn(duration: AppTheme.mediumAnimation)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                          ),

                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing32,
                        ),
                      ),

                      // Description Card
                      _buildDescriptionCard(context, type, detailedDescription)
                          .animate()
                          .fadeIn(
                            duration: AppTheme.mediumAnimation,
                            delay: 200.ms,
                          )
                          .slideY(begin: 0.3, end: 0),

                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing24,
                        ),
                      ),

                      // Number Meaning Card
                      _buildNumberMeaningCard(context, number)
                          .animate()
                          .fadeIn(
                            duration: AppTheme.mediumAnimation,
                            delay: 400.ms,
                          )
                          .slideY(begin: 0.3, end: 0),

                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing24,
                        ),
                      ),

                      // Personal Insights Card
                      _buildPersonalInsightsCard(context, type, number, result)
                          .animate()
                          .fadeIn(
                            duration: AppTheme.mediumAnimation,
                            delay: 600.ms,
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
                            delay: 800.ms,
                          )
                          .slideY(begin: 0.3, end: 0),

                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing32,
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildHeroNumber(BuildContext context, int number) {
    return Card(
      child: Container(
        decoration: AppTheme.getPrimaryGradientDecoration(context),
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing40),
        ),
        child: Column(
          children: [
            // Large Number Display
            Container(
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
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha((0.3 * 255).toInt()),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AnimatedNumberDisplay(
                      number: number,
                      size: ResponsiveUtils.responsiveValue(
                        context: context,
                        mobile: 60.0,
                        tablet: 70.0,
                        desktop: 80.0,
                      ),
                      color: Colors.white,
                      duration: const Duration(milliseconds: 1500),
                    ),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: 3000.ms,
                  color: Colors.white.withAlpha((0.3 * 255).toInt()),
                ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),

            // Type Name
            Text(
              type.displayName,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 24.0,
                  tablet: 28.0,
                  desktop: 32.0,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing8),
            ),

            // Short Description
            Text(
              _getShortDescription(type),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withAlpha((0.9 * 255).toInt()),
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
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(
    BuildContext context,
    NumerologyType type,
    String description,
  ) {
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
                  _getTypeIcon(type),
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    'About Your ${type.displayName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
            ),

            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 16.0,
                  tablet: 17.0,
                  desktop: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberMeaningCard(BuildContext context, int number) {
    final meanings = _getNumberKeywords(number);

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
                Icon(Icons.psychology, color: AppTheme.primaryPurple, size: 24),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    'Number $number Characteristics',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
            ),

            // Keywords
            Wrap(
              spacing: AppTheme.spacing8,
              runSpacing: AppTheme.spacing8,
              children: meanings.map((meaning) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing12,
                    vertical: AppTheme.spacing64,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Text(
                    meaning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInsightsCard(
    BuildContext context,
    NumerologyType type,
    int number,
    NumerologyResult result,
  ) {
    final insights = _getPersonalInsights(type, number, result);

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
                  Icons.lightbulb_outline,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Text(
                    'Personal Insights',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
            ),

            // Insights List
            ...insights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < insights.length - 1 ? AppTheme.spacing12 : 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                    Expanded(
                      child: Text(
                        insight,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back to Results Button
        GradientButton(
          onPressed: () => AppNavigator.toResults(context),
          text: 'Back to All Numbers',
          icon: Icons.grid_view,
        ),

        SizedBox(
          height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
        ),

        // Calculate New Button
        OutlinedGradientButton(
          onPressed: () => AppNavigator.toWelcome(context),
          text: 'Calculate New Numbers',
          icon: Icons.refresh,
        ),
      ],
    );
  }

  String _getShortDescription(NumerologyType type) {
    switch (type) {
      case NumerologyType.lifePathNumber:
        return 'Your life\'s journey and purpose';
      case NumerologyType.birthdayNumber:
        return 'Your natural talents and abilities';
      case NumerologyType.expressionNumber:
        return 'Your life\'s mission and goals';
      case NumerologyType.soulUrgeNumber:
        return 'Your inner desires and motivations';
      case NumerologyType.personalityNumber:
        return 'How others perceive you';
      case NumerologyType.driverNumber:
        return 'Your basic nature and driving force in life.';
      case NumerologyType.destinyNumber:
        return 'Your life\'s destiny and ultimate goal.';
      case NumerologyType.firstNameNumber:
        return 'How you present yourself to the world.';
      case NumerologyType.fullNameNumber:
        return 'Your complete identity and life expression.';
    }
  }

  IconData _getTypeIcon(NumerologyType type) {
    switch (type) {
      case NumerologyType.lifePathNumber:
        return Icons.route;
      case NumerologyType.birthdayNumber:
        return Icons.cake;
      case NumerologyType.expressionNumber:
        return Icons.star;
      case NumerologyType.soulUrgeNumber:
        return Icons.favorite;
      case NumerologyType.personalityNumber:
        return Icons.person;
      case NumerologyType.driverNumber:
        return Icons.directions_car;
      case NumerologyType.destinyNumber:
        return Icons.flag;
      case NumerologyType.firstNameNumber:
        return Icons.account_circle;
      case NumerologyType.fullNameNumber:
        return Icons.badge;
    }
  }

  List<String> _getNumberKeywords(int number) {
    switch (number) {
      case 1:
        return [
          'Leadership',
          'Independence',
          'Pioneer',
          'Ambitious',
          'Original',
        ];
      case 2:
        return [
          'Cooperation',
          'Harmony',
          'Diplomatic',
          'Sensitive',
          'Peaceful',
        ];
      case 3:
        return ['Creative', 'Expressive', 'Optimistic', 'Social', 'Artistic'];
      case 4:
        return ['Practical', 'Organized', 'Reliable', 'Hard-working', 'Stable'];
      case 5:
        return ['Freedom', 'Adventure', 'Versatile', 'Curious', 'Dynamic'];
      case 6:
        return [
          'Nurturing',
          'Responsible',
          'Caring',
          'Family-oriented',
          'Healing',
        ];
      case 7:
        return [
          'Spiritual',
          'Analytical',
          'Introspective',
          'Wise',
          'Mysterious',
        ];
      case 8:
        return [
          'Ambitious',
          'Material Success',
          'Authority',
          'Business-minded',
          'Powerful',
        ];
      case 9:
        return [
          'Humanitarian',
          'Compassionate',
          'Universal Love',
          'Generous',
          'Wise',
        ];
      default:
        return ['Unique', 'Special', 'Rare', 'Distinctive', 'Individual'];
    }
  }

  List<String> _getPersonalInsights(
    NumerologyType type,
    int number,
    NumerologyResult result,
  ) {
    final baseInsights = <String>[];

    switch (type) {
      case NumerologyType.lifePathNumber:
        baseInsights.addAll([
          'Your life path number $number suggests you are here to learn about ${_getNumberKeywords(number)[0].toLowerCase()}.',
          'You may find yourself naturally drawn to situations that require ${_getNumberKeywords(number)[1].toLowerCase()}.',
          'Your greatest challenges often involve balancing your ${_getNumberKeywords(number)[2].toLowerCase()} nature with practical needs.',
        ]);
        break;
      case NumerologyType.birthdayNumber:
        baseInsights.addAll([
          'Born on the ${result.dateOfBirth.day}th, you have natural ${_getNumberKeywords(number)[0].toLowerCase()} abilities.',
          'Your birthday number $number indicates you excel when you can be ${_getNumberKeywords(number)[1].toLowerCase()}.',
          'People often notice your ${_getNumberKeywords(number)[2].toLowerCase()} qualities first.',
        ]);
        break;
      case NumerologyType.expressionNumber:
        baseInsights.addAll([
          'Your name vibrates with the energy of ${_getNumberKeywords(number)[0].toLowerCase()}.',
          'You are meant to express yourself through ${_getNumberKeywords(number)[1].toLowerCase()} activities.',
          'Your life\'s work likely involves being ${_getNumberKeywords(number)[2].toLowerCase()} in some way.',
        ]);
        break;
      case NumerologyType.soulUrgeNumber:
        baseInsights.addAll([
          'Deep down, you crave ${_getNumberKeywords(number)[0].toLowerCase()} in your life.',
          'Your soul is motivated by the desire to be ${_getNumberKeywords(number)[1].toLowerCase()}.',
          'You feel most fulfilled when you can express your ${_getNumberKeywords(number)[2].toLowerCase()} nature.',
        ]);
        break;
      case NumerologyType.personalityNumber:
        baseInsights.addAll([
          'Others often see you as ${_getNumberKeywords(number)[0].toLowerCase()} and ${_getNumberKeywords(number)[1].toLowerCase()}.',
          'Your outer personality projects ${_getNumberKeywords(number)[2].toLowerCase()} energy.',
          'First impressions of you often include being ${_getNumberKeywords(number)[3].toLowerCase()}.',
        ]);
        break;
      case NumerologyType.driverNumber:
        baseInsights.addAll([
          'Your Driver Number (Mulank) $number is your basic nature and driving force.',
          'It reveals your instinctive reactions and how you approach new situations.',
          'Ruled by: ${result.planetaryRuler}.',
        ]);
        break;
      case NumerologyType.destinyNumber:
        baseInsights.addAll([
          'Your Destiny Number (Bhagyank) $number is your life’s ultimate goal.',
          'It shows your life’s direction and the opportunities you attract.',
          'Combination with Driver: ${result.driverDestinyMeaning}',
        ]);
        break;
      case NumerologyType.firstNameNumber:
        baseInsights.addAll([
          'Your First Name Number $number shows how you present yourself to the world.',
          'It influences first impressions and your social persona.',
          'Compatibility with Driver: ${result.nameCompatibility['firstNameWithDriver']}, Destiny: ${result.nameCompatibility['firstNameWithDestiny']}',
        ]);
        break;
      case NumerologyType.fullNameNumber:
        baseInsights.addAll([
          'Your Full Name Number $number is your complete identity and life expression.',
          'It reflects your overall destiny and the energy you project.',
          'Compatibility with Driver: ${result.nameCompatibility['fullNameWithDriver']}, Destiny: ${result.nameCompatibility['fullNameWithDestiny']}',
        ]);
        break;
    }

    return baseInsights;
  }

  void _shareNumber(BuildContext context, NumerologyType type, int number) {
    final text =
        '''
My ${type.displayName}: $number

${type.description}

Number $number represents: ${_getNumberKeywords(number).join(', ')}

Discover your numerology with Numero Uno!
''';

    // In a real app, you would use the share_plus package
    // Share.share(text);

    // For now, show a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share ${type.displayName}'),
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
