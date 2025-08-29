import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../models/numerology_type.dart';
import '../../utils/responsive_utils.dart';

class NumerologyCard extends StatelessWidget {
  final NumerologyType type;
  final int number;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsets? margin;

  const NumerologyCard({
    super.key,
    required this.type,
    required this.number,
    this.onTap,
    this.isSelected = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: margin,
        child: Card(
          elevation: isSelected ? 12 : 8,
          shadowColor: AppTheme.primaryPurple.withAlpha(isSelected ? 77 : 26),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Container(
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppTheme.getPrimaryGradient(context)
                    : AppTheme.getCardGradient(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppTheme.getPrimaryColor(context).withAlpha(128),
                        width: 1,
                      ),
              ),
              padding: EdgeInsets.all(
                ResponsiveUtils.getSpacing(context, AppTheme.spacing20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Number Circle
                  _buildNumberCircle(context),

                  SizedBox(
                    height: ResponsiveUtils.getSpacing(
                      context,
                      AppTheme.spacing16,
                    ),
                  ),

                  // Title
                  _buildTitle(context),

                  SizedBox(
                    height: ResponsiveUtils.getSpacing(
                      context,
                      AppTheme.spacing8,
                    ),
                  ),

                  // Description Preview
                  _buildDescriptionPreview(context),

                  SizedBox(
                    height: ResponsiveUtils.getSpacing(
                      context,
                      AppTheme.spacing12,
                    ),
                  ),

                  // Tap Indicator
                  _buildTapIndicator(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberCircle(BuildContext context) {
    final size = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 60.0,
      tablet: 70.0,
      desktop: 80.0,
    );

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.white.withAlpha(230), Colors.white],
                  )
                : AppTheme.getPrimaryGradient(context),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSelected ? Colors.white : AppTheme.primaryPurple)
                    .withAlpha(77),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 28.0,
                  tablet: 32.0,
                  desktop: 36.0,
                ),
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppTheme.getPrimaryColor(context)
                    : Colors.white,
              ),
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 3000.ms,
          color: (isSelected ? AppTheme.primaryPurple : Colors.white).withAlpha(
            77,
          ),
        );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      type.displayName,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: ResponsiveUtils.responsiveValue(
          context: context,
          mobile: 16.0,
          tablet: 18.0,
          desktop: 20.0,
        ),
        fontWeight: FontWeight.w600,
        color: isSelected ? Colors.white : AppTheme.getTextColor(context),
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescriptionPreview(BuildContext context) {
    final preview = _getShortDescription(type);

    return Text(
      preview,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: ResponsiveUtils.responsiveValue(
          context: context,
          mobile: 12.0,
          tablet: 13.0,
          desktop: 14.0,
        ),
        color: isSelected
            ? Colors.white.withAlpha(230)
            : AppTheme.getTextLightColor(context),
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTapIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withAlpha(51)
            : AppTheme.getPrimaryColor(context).withAlpha(26),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tap to explore',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ResponsiveUtils.responsiveValue(
                context: context,
                mobile: 10.0,
                tablet: 11.0,
                desktop: 12.0,
              ),
              color: isSelected
                  ? Colors.white.withAlpha(204)
                  : AppTheme.getPrimaryColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppTheme.spacing4),
          Icon(
            Icons.arrow_forward_ios,
            size: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: 10.0,
              tablet: 11.0,
              desktop: 12.0,
            ),
            color: isSelected
                ? Colors.white.withAlpha(204)
                : AppTheme.getPrimaryColor(context),
          ),
        ],
      ),
    );
  }

  String _getShortDescription(NumerologyType type) {
    switch (type) {
      case NumerologyType.lifePathNumber:
        return 'Your life\'s purpose and journey';
      case NumerologyType.birthdayNumber:
        return 'Your natural talents and gifts';
      case NumerologyType.expressionNumber:
        return 'Your life\'s goal and mission';
      case NumerologyType.soulUrgeNumber:
        return 'Your inner desires and motivation';
      case NumerologyType.personalityNumber:
        return 'How others perceive you';
      case NumerologyType.driverNumber:
        return 'Your basic nature and drive';
      case NumerologyType.destinyNumber:
        return 'Your ultimate destiny';
      case NumerologyType.firstNameNumber:
        return 'Your social persona';
      case NumerologyType.fullNameNumber:
        return 'Your full identity';
    }
  }
}

// Compact version for smaller spaces
class CompactNumerologyCard extends StatelessWidget {
  final NumerologyType type;
  final int number;
  final VoidCallback? onTap;

  const CompactNumerologyCard({
    super.key,
    required this.type,
    required this.number,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          decoration: AppTheme.getCardDecoration(context).copyWith(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Row(
            children: [
              // Number Circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppTheme.getPrimaryGradient(context),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppTheme.spacing12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    Text(
                      _getShortDescription(type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextLightColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.getTextLightColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortDescription(NumerologyType type) {
    switch (type) {
      case NumerologyType.lifePathNumber:
        return 'Life\'s purpose';
      case NumerologyType.birthdayNumber:
        return 'Natural talents';
      case NumerologyType.expressionNumber:
        return 'Life\'s mission';
      case NumerologyType.soulUrgeNumber:
        return 'Inner desires';
      case NumerologyType.personalityNumber:
        return 'Outer perception';
      case NumerologyType.driverNumber:
        return 'Basic drive';
      case NumerologyType.destinyNumber:
        return 'Destiny path';
      case NumerologyType.firstNameNumber:
        return 'First name energy';
      case NumerologyType.fullNameNumber:
        return 'Full name energy';
    }
  }
}

// Animated number display
class AnimatedNumberDisplay extends StatelessWidget {
  final int number;
  final double size;
  final Color? color;
  final Duration duration;

  const AnimatedNumberDisplay({
    super.key,
    required this.number,
    this.size = 60,
    this.color,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: number),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          value.toString(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: color ?? AppTheme.primaryPurple,
          ),
        );
      },
    );
  }
}
