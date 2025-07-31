import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  final StorageService _storageService = StorageService();
  bool _initialized = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    await _storageService.initialize();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> _handleNameSubmit(BuildContext context) async {
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
    // Check local storage for results
    final results = _storageService.getNumerologyResults();
    final existing = results.where((r) => r.fullName.toLowerCase() == name).toList();
    if (existing.isNotEmpty) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/resultOverview', arguments: existing.first);
      setState(() {
        _loading = false;
      });
      return;
    }

    // Check Firestore for results for this name (case-insensitive)
    final firestoreResult = await _storageService.getNumerologyResultFromFirestoreByName(name);

    if (firestoreResult != null) {
      // Save to local storage
      await _storageService.saveNumerologyResult(firestoreResult);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/resultOverview', arguments: firestoreResult);
      setState(() {
        _loading = false;
      });
      return;
    }

    // Otherwise, navigate to calculation screen
    final navigator = Navigator.of(context);
    if (mounted) {
      navigator.pushReplacementNamed('/calculation', arguments: name);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                    decoration: const InputDecoration(labelText: 'Enter your name'),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
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
