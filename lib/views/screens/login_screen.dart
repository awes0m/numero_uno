import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../config/app_theme.dart';
import '../../services/storage_service.dart';
import '../../utils/responsive_utils.dart';
import '../widgets/app_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final nameController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _handleNameSubmit(BuildContext context) async {
    if (!mounted) return;
    final navigator = Navigator.of(context);

    // Check if storage is initialized
    if (!StorageService.isInitialized) {
      setState(() {
        _error = 'Storage not initialized. Please restart the app.';
      });
      return;
    }

    final storageService = ref.read(storageServiceProvider);
    setState(() {
      _loading = true;
      _error = null;
    });

    final name = nameController.text.trim().toLowerCase();
    if (name.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Please enter your name.';
      });
      return;
    }

    try {
      // Check local storage for results
      final results = storageService.getNumerologyResults();
      final existing = results
          .where((r) => r.fullName.toLowerCase() == name)
          .toList();
      if (existing.isNotEmpty) {
        setState(() {
          _loading = false;
        });
        navigator.pushReplacementNamed(
          '/resultOverview',
          arguments: existing.first,
        );
        return;
      }

      // Check Firestore for results for this name (case-insensitive)
      final firestoreResult = await storageService.getNumerologyResultByUserId(
        name,
      );

      if (firestoreResult != null) {
        // Save to local storage
        await storageService.saveNumerologyResult(firestoreResult);
        setState(() {
          _loading = false;
        });
        navigator.pushReplacementNamed(
          '/resultOverview',
          arguments: firestoreResult,
        );
        return;
      }

      // Otherwise, navigate to calculation screen
      navigator.pushReplacementNamed('/calculation', arguments: name);
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error accessing storage: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if storage is initialized before rendering the UI
    if (!StorageService.isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing storage...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Numero Uno')),
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            await _handleNameSubmit(context);
                          },
                          child: const Text('Continue'),
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
