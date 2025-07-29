// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/app_theme.dart';
import '../../models/app_state.dart';
import '../../providers/input_providers.dart';
import '../../viewmodels/input_viewmodel.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/gradient_button.dart';
import '../widgets/theme_toggle_fab.dart';
import '../widgets/app_footer.dart';
import '../../config/app_router.dart';

class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final formState = ref.watch(inputFormProvider);
    final formNotifier = ref.read(inputFormProvider.notifier);
    final appState = ref.watch(appStateProvider);
    final appNotifier = ref.read(appStateProvider.notifier);

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
        // Navigate to loading screen
        AppNavigator.toLoading(context);
      } else if (next.status == AppStatus.calculated) {
        // Navigate to results screen
        AppNavigator.toResults(context);
      } else if (next.status == AppStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Don't call clearError here to avoid infinite loop
      }
    });

    return Scaffold(
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
                          AppTheme.spacing64,
                        ),
                      ),

                      // Header
                      AppHeader(context: context)
                          .animate()
                          .fadeIn(duration: AppTheme.mediumAnimation)
                          .slideY(begin: -0.3, end: 0),

                      SizedBox(
                        height: ResponsiveUtils.getSpacing(
                          context,
                          AppTheme.spacing48,
                        ),
                      ),

                      // Form Card
                      _buildFormCard(
                            context,
                            nameController,
                            formState,
                            formNotifier,
                            appState,
                            appNotifier,
                          )
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

  Widget _buildFormCard(
    BuildContext context,
    TextEditingController nameController,
    InputFormState formState,
    InputViewModel formNotifier,
    AppState appState,
    AppStateNotifier appNotifier,
  ) {
    return Card(
      child: Container(
        decoration: AppTheme.getCardDecoration(context),
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

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
            ),

            // Full Name Field
            CustomTextField(
              controller: nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              errorText: formState.fullNameError,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing20),
            ),

            // Date of Birth Field
            CustomDatePicker(
              label: 'Date of Birth',
              hint: 'Select your date of birth',
              selectedDate: formState.dateOfBirth,
              onDateSelected: formNotifier.updateDateOfBirth,
              errorText: formState.dateOfBirthError,
            ),

            SizedBox(
              height: ResponsiveUtils.getSpacing(context, AppTheme.spacing32),
            ),

            // Submit Button
            GradientButton(
              onPressed: formState.isValid && !appState.isLoading
                  ? () => _handleSubmit(context, formNotifier, appNotifier)
                  : null,
              text: 'Calculate My Numbers',
              isLoading: appState.isLoading,
              icon: Icons.calculate,
            ),

            if (!formState.isValid) ...[
              SizedBox(
                height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12),
              ),
              Text(
                'Please fill in all fields correctly to continue',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textLight),
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
    InputViewModel formNotifier,
    AppStateNotifier appNotifier,
  ) {
    final userData = formNotifier.createUserData();
    if (userData != null) {
      appNotifier.calculateNumerology(userData);
    }
  }
}

