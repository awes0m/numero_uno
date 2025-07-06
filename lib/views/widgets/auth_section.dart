import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:numero_uno/models/app_state.dart';
import '../../config/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../utils/responsive_utils.dart';
import 'gradient_button.dart';

class AuthSection extends ConsumerWidget {
  const AuthSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final appNotifier = ref.read(appStateProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    return Card(
      child: Container(
        decoration: AppTheme.cardDecoration,
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Auth Status
            _buildAuthStatus(context, currentUser),
            
            SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing20)),
            
            // Auth Actions
            if (currentUser == null) ...[
              _buildSignInSection(context, appState, appNotifier),
            ] else ...[
              _buildSignedInSection(context, currentUser, appState, appNotifier),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthStatus(BuildContext context, User? currentUser) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: currentUser != null ? AppTheme.successGreen : AppTheme.textLight,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5)),
        
        const SizedBox(width: AppTheme.spacing12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser != null ? 'Signed In' : 'Not Signed In',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: currentUser != null ? AppTheme.successGreen : AppTheme.textLight,
                ),
              ),
              if (currentUser != null) ...[
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  currentUser.displayName ?? currentUser.email ?? 'Anonymous User',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInSection(
    BuildContext context,
    AppState appState,
    AppStateNotifier appNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info Text
        Text(
          'Sign in to save your calculations and access them from any device.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textLight,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing20)),
        
        // Google Sign In Button
        _buildGoogleSignInButton(context, appState, appNotifier),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing12)),
        
        // Continue Without Sign In
        TextButton(
          onPressed: appState.isLoading ? null : () => appNotifier.signInAnonymously(),
          child: Text(
            'Continue without signing in',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textLight,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(
    BuildContext context,
    AppState appState,
    AppStateNotifier appNotifier,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.softGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: appState.isLoading ? null : () => appNotifier.signInWithGoogle(),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (appState.isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                ] else ...[
                  // Google Logo
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://developers.google.com/identity/images/g-logo.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacing12),
                ],
                Text(
                  appState.isLoading ? 'Signing in...' : 'Continue with Google',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignedInSection(
    BuildContext context,
    User currentUser,
    AppState appState,
    AppStateNotifier appNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // User Info
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: AppTheme.lightPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryPurple,
                backgroundImage: currentUser.photoURL != null
                    ? NetworkImage(currentUser.photoURL!)
                    : null,
                child: currentUser.photoURL == null
                    ? Text(
                        (currentUser.displayName?.isNotEmpty == true
                            ? currentUser.displayName![0]
                            : currentUser.email?.isNotEmpty == true
                                ? currentUser.email![0]
                                : 'A').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              
              const SizedBox(width: AppTheme.spacing12),
              
              // User Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.displayName ?? 'Anonymous User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentUser.email != null) ...[
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        currentUser.email!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.getSpacing(context, AppTheme.spacing16)),
        
        // Sign Out Button
        OutlinedGradientButton(
          onPressed: appState.isLoading ? null : () => appNotifier.signOut(),
          text: appState.isLoading ? 'Signing out...' : 'Sign Out',
          isLoading: appState.isLoading,
          icon: Icons.logout,
        ),
      ],
    );
  }
}