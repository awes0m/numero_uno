import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';

class SystemSelector extends StatelessWidget {
  final String selectedSystem;
  final ValueChanged<String> onSystemChanged;
  final String? errorText;

  const SystemSelector({
    super.key,
    required this.selectedSystem,
    required this.onSystemChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
          child: Row(
            children: [
              Icon(
                Icons.calculate,
                size: 20,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(width: AppTheme.spacing8),
              Text(
                'Numerology System',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
        ),

        // System Options
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: errorText != null 
                  ? AppTheme.errorRed 
                  : AppTheme.lightPurple.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              _buildSystemOption(
                context,
                'both',
                'Both Systems',
                'Compare Pythagorean & Chaldean results',
                Icons.compare_arrows,
                isFirst: true,
              ),
              _buildDivider(),
              _buildSystemOption(
                context,
                'pythagorean',
                'Pythagorean',
                'Traditional Western numerology system',
                Icons.school,
              ),
              _buildDivider(),
              _buildSystemOption(
                context,
                'chaldean',
                'Chaldean',
                'Ancient Babylonian numerology system',
                Icons.history_edu,
                isLast: true,
              ),
            ],
          ),
        ),

        // Error Text
        if (errorText != null) ...[
          const SizedBox(height: AppTheme.spacing8),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.errorRed,
            ),
          ),
        ],

        // Info Text
        const SizedBox(height: AppTheme.spacing12),
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
                  'Choose "Both Systems" to see how different numerology systems interpret your numbers.',
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
    );
  }

  Widget _buildSystemOption(
    BuildContext context,
    String value,
    String title,
    String description,
    IconData icon, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = selectedSystem == value;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSystemChanged(value),
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(AppTheme.radiusMedium) : Radius.zero,
          bottom: isLast ? const Radius.circular(AppTheme.radiusMedium) : Radius.zero,
        ),
        child: Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.getSpacing(context, AppTheme.spacing16),
          ),
          child: Row(
            children: [
              // Radio Button
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? AppTheme.primaryPurple 
                        : AppTheme.lightPurple.withOpacity(0.5),
                    width: 2,
                  ),
                  color: isSelected 
                      ? AppTheme.primaryPurple 
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),

              const SizedBox(width: AppTheme.spacing12),

              // Icon
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryPurple.withOpacity(0.1)
                      : AppTheme.lightPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected 
                      ? AppTheme.primaryPurple 
                      : AppTheme.lightPurple,
                ),
              ),

              const SizedBox(width: AppTheme.spacing12),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? AppTheme.primaryPurple 
                            : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textLight,
                        fontSize: 12,
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

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      color: AppTheme.lightPurple.withOpacity(0.2),
    );
  }
}