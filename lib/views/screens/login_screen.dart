import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../config/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/app_header.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final bool isAuthenticated;
  final bool isGuest;
  final String? error;
  AuthState({required this.isAuthenticated, this.isGuest = false, this.error});

  AuthState copyWith({bool? isAuthenticated, bool? isGuest, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState(isAuthenticated: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message ?? 'Login failed');
    } catch (e) {
      state = state.copyWith(error: 'Login failed');
    }
  }

  Future<void> register(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState(isAuthenticated: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(error: e.message ?? 'Registration failed');
    } catch (e) {
      state = state.copyWith(error: 'Registration failed');
    }
  }

  void continueAsGuest() {
    state = AuthState(isAuthenticated: true, isGuest: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login or Continue as Guest')),
      body: Container(
        decoration: AppTheme.getCardDecoration(context),
        padding: EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, AppTheme.spacing24),
        ),
        child: Card(
          child: ResponsiveContainer(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppHeader(context: context),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (authState.error != null)
                    Text(
                      authState.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          ref.read(authProvider.notifier).clearError();
                          await ref
                              .read(authProvider.notifier)
                              .login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          ref.read(authProvider.notifier).clearError();
                          await ref
                              .read(authProvider.notifier)
                              .register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).continueAsGuest();
                    },
                    child: const Text('Continue as Guest'),
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
