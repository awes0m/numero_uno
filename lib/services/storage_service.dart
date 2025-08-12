import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_data.dart';
import '../models/numerology_result.dart';

class StorageService {
  static const String _userInputBoxName = 'user_inputs';
  static const String _numerologyResultBoxName = 'numerology_results';
  static const String _lastCalculationKey = 'last_calculation';

  static StorageService? _instance;

  static StorageService get instance {
    if (_instance == null) {
      throw StateError(
        'StorageService has not been initialized. Please call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if storage service is initialized
  static bool get isInitialized => _instance != null;

  /// Get initialization status with details
  static Map<String, dynamic> getInitializationStatus() {
    return {
      'isInitialized': isInitialized,
      'hiveInitialized':
          Hive.isBoxOpen('user_inputs') ||
          Hive.isBoxOpen('numerology_results'),
      'adaptersRegistered': {
        'UserData': Hive.isAdapterRegistered(0),
        'NumerologyResult': Hive.isAdapterRegistered(1),
              },
      'boxesOpen': isInitialized
          ? {
              'userInputs': _instance!._userInputBox.isOpen,
              'numerologyResults': _instance!._numerologyResultBox.isOpen,
            }
          : null,
    };
  }

  final Box<UserData> _userInputBox;
  final Box<NumerologyResult> _numerologyResultBox;
  final SharedPreferences _prefs;

  StorageService._({
    required Box<UserData> userInputBox,
    required Box<NumerologyResult> numerologyResultBox,
    required SharedPreferences prefs,
  }) : _userInputBox = userInputBox,
       _numerologyResultBox = numerologyResultBox,
       _prefs = prefs;

  /// Initialize storage service
  static Future<void> initialize() async {
    if (_instance != null) {
      return;
    }

    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Register adapters with proper error handling
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserDataAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(NumerologyResultAdapter());
      }
      // NumerologyType and CompatibilityResult adapters removed/not used currently

      // Open boxes with error handling
      final userInputBox = await Hive.openBox<UserData>(_userInputBoxName);
      final numerologyResultBox = await Hive.openBox<NumerologyResult>(
        _numerologyResultBoxName,
      );

      // Initialize SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      _instance = StorageService._(
        userInputBox: userInputBox,
        numerologyResultBox: numerologyResultBox,
        prefs: prefs,
      );

      debugPrint('✅ StorageService initialized successfully');
      debugPrint('📊 Storage stats: ${_instance!.getStorageStats()}');
    } catch (e) {
      debugPrint('❌ StorageService initialization failed: $e');
      rethrow;
    }
  }

  /// Save user input
  Future<void> saveUserInput(
    UserData userInput, {
    String? userId,
    bool isGuest = true,
  }) async {
    if (userId != null && !isGuest) {
      // Save to Firestore under user's UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.toLowerCase()) // Ensure userId is lowercased
          .collection('inputs')
          .add(userInput.toJson());
    } else {
      final key = 'anonymous_${userInput.createdAt.millisecondsSinceEpoch}';
      await _userInputBox.put(key, userInput);
    }
  }

  /// Get all user inputs from local storage
  List<UserData> getUserInputs() {
    return _userInputBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Save numerology result
  Future<void> saveNumerologyResult(
    NumerologyResult result, {
    String? userId,
    bool isGuest = true,
  }) async {
    if (userId != null && !isGuest) {
      // Save to Firestore under user's UID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.toLowerCase()) // Ensure userId is lowercased
          .collection('results')
          .add(result.toJson());
    } else {
      // Use userId if available, otherwise use name (for backwards compatibility)
      final keyPrefix = userId?.toLowerCase() ?? result.fullName.toLowerCase();
      final key = '${keyPrefix}_${result.calculatedAt.millisecondsSinceEpoch}';
      await _numerologyResultBox.put(key, result);

      // Save as last calculation
      await _prefs.setString(_lastCalculationKey, key);
    }
  }

  /// Get numerology results from local storage
  List<NumerologyResult> getNumerologyResults() {
    return _numerologyResultBox.values.toList()
      ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
  }

  /// Get the latest numerology result from Firestore for a given user ID
  Future<NumerologyResult?> getNumerologyResultByUserId(String userId) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toLowerCase())
        .collection('results')
        .orderBy('calculatedAt', descending: true)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return NumerologyResult.fromJson(query.docs.first.data());
    }
    return null;
  }

  /// Get last calculation from local storage
  NumerologyResult? getLastCalculation() {
    final lastKey = _prefs.getString(_lastCalculationKey);
    if (lastKey != null) {
      return _numerologyResultBox.get(lastKey);
    }
    return null;
  }

  /// Clear all local data
  Future<void> clearAllData() async {
    await _userInputBox.clear();
    await _numerologyResultBox.clear();
    await _prefs.clear();
  }

  /// Get local storage statistics
  Map<String, int> getStorageStats() {
    return {
      'userInputs': _userInputBox.length,
      'numerologyResults': _numerologyResultBox.length,
    };
  }

  /// Close storage
  Future<void> close() async {
    try {
      await _userInputBox.close();
      await _numerologyResultBox.close();
      debugPrint('✅ Storage boxes closed successfully');
    } catch (e) {
      debugPrint('❌ Error closing storage boxes: $e');
    }
  }

  /// Reset storage service (for testing or recovery)
  static Future<void> reset() async {
    try {
      if (_instance != null) {
        await _instance!.close();
        _instance = null;
      }

      // Close all Hive boxes
      await Hive.close();

      debugPrint('✅ Storage service reset successfully');
    } catch (e) {
      debugPrint('❌ Error resetting storage service: $e');
      rethrow;
    }
  }

  /// Safe method to get instance without throwing
  static StorageService? get instanceOrNull => _instance;

  /// Check if storage operations are safe to perform
  static bool get canPerformStorageOperations {
    return isInitialized &&
        _instance!._userInputBox.isOpen &&
        _instance!._numerologyResultBox.isOpen;
  }
}
