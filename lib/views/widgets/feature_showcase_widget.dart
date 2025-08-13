import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';

class FeatureShowcaseWidget extends StatelessWidget {
  const FeatureShowcaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Interactive Results View',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = AppTheme.primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 30),
                            ),
                        ),
                      ),
                      Text(
                        'Enhanced with TabBar navigation and organized sections',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacing24),

            // Feature Comparison
            _buildComparisonSection(context),

            const SizedBox(height: AppTheme.spacing24),

            // Key Benefits
            _buildBenefitsSection(context),

            const SizedBox(height: AppTheme.spacing24),

            // Technical Highlights
            _buildTechnicalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Before vs After',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryPurple,
          ),
        ),

        const SizedBox(height: AppTheme.spacing16),

        Row(
          children: [
            // Before
            Expanded(
              child: Container(
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
                        Icon(Icons.view_list, size: 16, color: Colors.red),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          'Classic View',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    ...[
                      '• Long scrollable page',
                      '• All info at once',
                      '• Limited organization',
                      '• Mobile unfriendly',
                    ].map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.red.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: AppTheme.spacing16),

            // Arrow
            Container(
                  padding: const EdgeInsets.all(AppTheme.spacing8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms),

            const SizedBox(width: AppTheme.spacing16),

            // After
            Expanded(
              child: Container(
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
                        Icon(Icons.tab, size: 16, color: Colors.green),
                        const SizedBox(width: AppTheme.spacing4),
                        Text(
                          'Interactive View',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacing8),
                    ...[
                      '• 5 organized tabs',
                      '• Focused sections',
                      '• Logical grouping',
                      '• Mobile optimized',
                    ].map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.green.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.speed,
        'title': 'Faster Navigation',
        'description': 'Direct access to specific information types',
        'color': Colors.blue,
      },
      {
        'icon': Icons.phone_android,
        'title': 'Mobile Optimized',
        'description': 'Touch-friendly interface with smooth animations',
        'color': Colors.green,
      },
      {
        'icon': Icons.psychology,
        'title': 'Reduced Cognitive Load',
        'description': 'Information chunked into digestible sections',
        'color': Colors.purple,
      },
      {
        'icon': Icons.extension,
        'title': 'Scalable Design',
        'description': 'Easy to add new features without cluttering',
        'color': Colors.orange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Benefits',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryPurple,
          ),
        ),

        const SizedBox(height: AppTheme.spacing16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: AppTheme.spacing12,
            mainAxisSpacing: AppTheme.spacing12,
          ),
          itemCount: benefits.length,
          itemBuilder: (context, index) {
            final benefit = benefits[index];
            final color = benefit['color'] as Color;

            return Container(
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(benefit['icon'] as IconData, color: color, size: 20),
                      const SizedBox(width: AppTheme.spacing8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              benefit['title'] as String,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              benefit['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: color.withOpacity(0.8)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate(delay: (index * 100).ms)
                .fadeIn(duration: 500.ms)
                .slideX(begin: 0.3, end: 0);
          },
        ),
      ],
    );
  }

  Widget _buildTechnicalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient.scale(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: AppTheme.primaryPurple, size: 20),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                'Technical Highlights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing12),

          Wrap(
            spacing: AppTheme.spacing8,
            runSpacing: AppTheme.spacing8,
            children:
                [
                      'HookConsumerWidget',
                      'TabController',
                      'Responsive Design',
                      'Riverpod State Management',
                      'Flutter Animate',
                      'Modular Architecture',
                    ]
                    .map(
                      (tech) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall,
                          ),
                          border: Border.all(
                            color: AppTheme.primaryPurple.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          tech,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

// Extension to scale gradients (if not already defined)
extension GradientScale on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
    );
  }
}
