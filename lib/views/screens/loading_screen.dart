// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ResponsiveContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              _buildAnimatedLogo(context),
              
              SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing48)),
              
              // Loading Text
              _buildLoadingText(context),
              
              SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
              
              // Progress Indicator
              _buildProgressIndicator(context),
              
              SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24)),
              
              // Loading Steps
              _buildLoadingSteps(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(BuildContext context) {
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
        gradient: AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 60,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .rotate(duration: 3000.ms)
        .then()
        .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3));
  }

  Widget _buildLoadingText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Calculating Your Numbers',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.3, end: 0),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16)),
        
        Text(
          'Unveiling the mysteries hidden in your name and birth date...',
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
        )
            .animate()
            .fadeIn(duration: 800.ms, delay: 300.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return SizedBox(
      width: ResponsiveUtils.responsiveValue(
        context: context,
        mobile: 200.0,
        tablet: 250.0,
        desktop: 300.0,
      ),
      child: LinearProgressIndicator(
        backgroundColor: AppTheme.lightPurple.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
        minHeight: 6,
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.5));
  }

  Widget _buildLoadingSteps(BuildContext context) {
    final steps = [
      'Analyzing your name vibrations',
      'Calculating life path number',
      'Determining soul urge number',
      'Computing expression number',
      'Finalizing personality insights',
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              )
                  .animate(delay: (index * 500).ms)
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0, 0), end: const Offset(1, 1)),
              
              const SizedBox(width: AppTheme.spacing12),
              
              Text(
                step,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textLight,
                  fontSize: ResponsiveUtils.responsiveValue(
                    context: context,
                    mobile: 14.0,
                    tablet: 15.0,
                    desktop: 16.0,
                  ),
                ),
              )
                  .animate(delay: (index * 500 + 200).ms)
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: 0.3, end: 0),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Alternative loading screen with mystical elements
class MysticalLoadingScreen extends StatelessWidget {
  const MysticalLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: Stack(
          children: [
            // Floating particles
            ..._buildFloatingParticles(),
            
            // Main content
            ResponsiveContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mystical circle
                  _buildMysticalCircle(context),
                  
                  SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing48)),
                  
                  // Loading text
                  Text(
                    'Consulting the Universe',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = AppTheme.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 300, 50),
                        ),
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .slideY(begin: 0.3, end: 0),
                  
                  SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16)),
                  
                  Text(
                    'The cosmic energies are aligning to reveal your numerological destiny...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textLight,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 1000.ms, delay: 500.ms)
                      .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMysticalCircle(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryPurple.withOpacity(0.3),
              width: 2,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 8000.ms),
        
        // Middle ring
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.secondaryBlue.withOpacity(0.5),
              width: 2,
            ),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .rotate(duration: 6000.ms),
        
        // Inner circle
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 0),
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
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
      ],
    );
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(20, (index) {
      return Positioned(
        left: (index * 37) % 300.0,
        top: (index * 67) % 600.0,
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .moveY(
              begin: 0,
              end: -50,
              duration: Duration(milliseconds: 3000 + (index * 200)),
            )
            .fadeIn(duration: 1000.ms)
            .then()
            .fadeOut(duration: 1000.ms),
      );
    });
  }
}