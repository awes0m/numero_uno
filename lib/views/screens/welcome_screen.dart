// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../models/app_state.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/auth_section.dart';
import '../widgets/gradient_button.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final formState = ref.watch(userInputFormProvider);
    final formNotifier = ref.read(userInputFormProvider.notifier);
    final appState = ref.watch(appStateProvider);
    final appNotifier = ref.read(appStateProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    // Listen to form changes
    useEffect(() {
      void listener() {
        formNotifier.updateFullName(nameController.text);
      }
      nameController.addListener(listener);
      return () => nameController.removeListener(listener);
    }, [nameController]);

    // Handle app state changes
    ref.listen(appStateProvider, (previous, next) {
      if (next.status == AppStatus.calculating) {
        // Navigation will be handled by router redirect
      } else if (next.status == AppStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        appNotifier.clearError();
      }
    });

    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing64)),
                
                // Header
                _buildHeader(context)
                    .animate()
                    .fadeIn(duration: AppTheme.mediumAnimation)
                    .slideY(begin: -0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing48)),
                
                // Form Card
                _buildFormCard(
                  context,
                  nameController,
                  formState,
                  formNotifier,
                  appState,
                  appNotifier,
                  currentUser,
                ).animate()
                    .fadeIn(duration: AppTheme.mediumAnimation, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
                
                // Auth Section
                AuthSection()
                    .animate()
                    .fadeIn(duration: AppTheme.mediumAnimation, delay: 400.ms)
                    .slideY(begin: 0.3, end: 0),
                
                SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // App Icon/Logo
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
        ),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24)),
        
        // Title
        Text(
          'Numero Uno',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: 32.0,
              tablet: 36.0,
              desktop: 40.0,
            ),
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = AppTheme.primaryGradient.createShader(
                const Rect.fromLTWH(0, 0, 200, 70),
              ),
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12)),
        
        // Subtitle
        Text(
          'Discover the mystical power of numbers\nand unlock your destiny',
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
      ],
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    TextEditingController nameController,
    UserInputFormState formState,
    UserInputFormNotifier formNotifier,
    AppState appState,
    AppStateNotifier appNotifier,
    User? currentUser,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form Title
            Text(
              'Enter Your Details',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: ResponsiveUtils.responsiveValue(
                  context: context,
                  mobile: 20.0,
                  tablet: 22.0,
                  desktop: 24.0,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24)),
            
            // Full Name Field
            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              errorText: formState.fullNameError,
              textInputAction: TextInputAction.next,
            ),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing20)),
            
            // Date of Birth Field
            CustomDatePicker(
              label: 'Date of Birth',
              hint: 'Select your date of birth',
              selectedDate: formState.dateOfBirth,
              onDateSelected: formNotifier.updateDateOfBirth,
              errorText: formState.dateOfBirthError,
            ),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32)),
            
            // Submit Button
            GradientButton(
              onPressed: formState.isValid && !appState.isLoading
                  ? () => _handleSubmit(context, formNotifier, appNotifier, currentUser)
                  : null,
              text: 'Calculate My Numbers',
              isLoading: appState.isLoading,
              icon: Icons.calculate,
            ),
            
            if (!formState.isValid) ...[
              SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12)),
              Text(
                'Please fill in all fields correctly to continue',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleSubmit(
    BuildContext context,
    UserInputFormNotifier formNotifier,
    AppStateNotifier appNotifier,
    User? currentUser,
  ) {
    final userInput = formNotifier.createUserInput(currentUser?.uid);
    if (userInput != null) {
      appNotifier.calculateNumerology(userInput);
    }
  }
}