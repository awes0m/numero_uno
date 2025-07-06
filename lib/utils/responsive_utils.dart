import 'package:flutter/material.dart';
import '../config/app_theme.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveUtils {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < AppTheme.mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < AppTheme.tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(AppTheme.spacing16);
      case DeviceType.tablet:
        return const EdgeInsets.all(AppTheme.spacing24);
      case DeviceType.desktop:
        return const EdgeInsets.all(AppTheme.spacing32);
    }
  }

  static double getContentMaxWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 600;
      case DeviceType.desktop:
        return 800;
    }
  }

  static int getCrossAxisCount(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }

  static double getCardAspectRatio(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.5;
      case DeviceType.tablet:
        return 1.3;
      case DeviceType.desktop:
        return 1.2;
    }
  }

  static double getFontSizeMultiplier(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.1;
      case DeviceType.desktop:
        return 1.2;
    }
  }

  static double getSpacing(BuildContext context, double baseSpacing) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSpacing;
      case DeviceType.tablet:
        return baseSpacing * 1.2;
      case DeviceType.desktop:
        return baseSpacing * 1.4;
    }
  }

  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

// Responsive widget wrapper
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.responsiveBuilder(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

// Responsive container with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? ResponsiveUtils.getScreenPadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? ResponsiveUtils.getContentMaxWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Responsive grid view
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.mainAxisSpacing = AppTheme.spacing16,
    this.crossAxisSpacing = AppTheme.spacing16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getCrossAxisCount(context);
    final aspectRatio = childAspectRatio ?? ResponsiveUtils.getCardAspectRatio(context);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding ?? ResponsiveUtils.getScreenPadding(context),
      children: children,
    );
  }
}