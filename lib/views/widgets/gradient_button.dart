import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    
    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? (gradient ?? AppTheme.primaryGradient)
            : LinearGradient(
                colors: [
                  AppTheme.textLight.withOpacity(0.3),
                  AppTheme.textLight.withOpacity(0.3),
                ],
              ),
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing24,
              vertical: AppTheme.spacing16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isEnabled ? Colors.white : AppTheme.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                ] else if (icon != null) ...[
                  Icon(
                    icon,
                    color: isEnabled ? Colors.white : AppTheme.textLight,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                ],
                Text(
                  text,
                  style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isEnabled ? Colors.white : AppTheme.textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Outlined gradient button
class OutlinedGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final double borderWidth;

  const OutlinedGradientButton({
    super.key,
    this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.textStyle,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final effectiveGradient = gradient ?? AppTheme.primaryGradient;
    
    return Container(
      width: width,
      height: height ?? 56,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
        gradient: isEnabled ? effectiveGradient : null,
        border: !isEnabled
            ? Border.all(
                color: AppTheme.textLight.withOpacity(0.3),
                width: borderWidth,
              )
            : null,
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium - borderWidth),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium - borderWidth),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing24,
                vertical: AppTheme.spacing16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled ? AppTheme.primaryPurple : AppTheme.textLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                  ] else if (icon != null) ...[
                    ShaderMask(
                      shaderCallback: (bounds) => isEnabled
                          ? effectiveGradient.createShader(bounds)
                          : LinearGradient(
                              colors: [AppTheme.textLight, AppTheme.textLight],
                            ).createShader(bounds),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacing12),
                  ],
                  ShaderMask(
                    shaderCallback: (bounds) => isEnabled
                        ? effectiveGradient.createShader(bounds)
                        : LinearGradient(
                            colors: [AppTheme.textLight, AppTheme.textLight],
                          ).createShader(bounds),
                    child: Text(
                      text,
                      style: textStyle ?? Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Icon gradient button
class IconGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final double size;
  final Gradient? gradient;

  const IconGradientButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.size = 48,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final effectiveGradient = gradient ?? AppTheme.primaryGradient;
    
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: isEnabled ? effectiveGradient : null,
          color: !isEnabled ? AppTheme.textLight.withOpacity(0.3) : null,
          shape: BoxShape.circle,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(size / 2),
            child: Icon(
              icon,
              color: Colors.white,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}