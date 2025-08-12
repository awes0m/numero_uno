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
          Hive.isBoxOpen('user_inputs') || Hive.isBoxOpen('numerology_results'),
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
    // Always save to local storage first
    final key = userId != null
        ? '${userId.toLowerCase()}_${userInput.createdAt.millisecondsSinceEpoch}'
        : 'anonymous_${userInput.createdAt.millisecondsSinceEpoch}';
    await _userInputBox.put(key, userInput);

    // Save to Firestore if userId (email) is provided
    if (userId != null && userId.isNotEmpty) {
      try {
        // Save user input data to the same document in numerology_result collection
        await FirebaseFirestore.instance
            .collection('numerology_result')
            .doc(userId.toLowerCase())
            .set({
              'userInput': userInput.toJson(),
              'email': userId.toLowerCase(),
              'lastUpdated': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        debugPrint('✅ User input saved to Firestore for: $userId');
      } catch (e) {
        debugPrint('❌ Error saving user input to Firestore: $e');
        // Don't rethrow - local storage already succeeded
      }
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
    // Always save to local storage first
    final keyPrefix = userId?.toLowerCase() ?? result.fullName.toLowerCase();
    final key = '${keyPrefix}_${result.calculatedAt.millisecondsSinceEpoch}';
    await _numerologyResultBox.put(key, result);
    await _prefs.setString(_lastCalculationKey, key);

    // Save to Firestore if userId (email) is provided
    if (userId != null && userId.isNotEmpty) {
      try {
        // Convert result to JSON and ensure all data types are Firestore-compatible
        final resultJson = result.toJson();

        // Debug: Log problematic data types
        debugPrint('🔍 Checking data types before Firestore save:');
        resultJson.forEach((key, value) {
          if (value is Map && key.contains('Grid')) {
            debugPrint(
              '  $key: ${value.runtimeType} with keys: ${(value).keys.map((k) => '${k.runtimeType}:$k').join(', ')}',
            );
          }
        });

        // Ensure all map keys are strings for Firestore compatibility
        final firestoreData = <String, dynamic>{
          ...resultJson,
          'email': userId.toLowerCase(),
          'lastUpdated': FieldValue.serverTimestamp(),
        };

        // Save to 'numerology_result' collection with email as document ID
        await FirebaseFirestore.instance
            .collection('numerology_result')
            .doc(userId.toLowerCase()) // Use email as document ID
            .set(
              firestoreData,
              SetOptions(merge: true),
            ); // Use merge to update existing document

        debugPrint('✅ Numerology result saved to Firestore for: $userId');
      } catch (e) {
        debugPrint('❌ Error saving to Firestore: $e');
        debugPrint('❌ Error details: ${e.toString()}');
        // Don't rethrow - local storage already succeeded
      }
    }
  }

  /// Get numerology results from local storage
  List<NumerologyResult> getNumerologyResults() {
    return _numerologyResultBox.values.toList()
      ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
  }

  /// Get the latest numerology result from Firestore for a given user ID (email)
  Future<NumerologyResult?> getNumerologyResultByUserId(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('numerology_result')
          .doc(userId.toLowerCase())
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        // Remove Firestore-specific fields before parsing
        data.remove('email');
        data.remove('lastUpdated');
        data.remove('userInput');
        return NumerologyResult.fromJson(data);
      }
    } catch (e) {
      debugPrint('❌ Error getting numerology result from Firestore: $e');
    }
    return null;
  }

  /// Get user input from Firestore for a given user ID (email)
  Future<UserData?> getUserInputByUserId(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('numerology_result')
          .doc(userId.toLowerCase())
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('userInput')) {
          return UserData.fromJson(data['userInput'] as Map<String, dynamic>);
        }
      }
    } catch (e) {
      debugPrint('❌ Error getting user input from Firestore: $e');
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

  /// Test Firestore connection and permissions
  Future<bool> testFirestoreConnection() async {
    try {
      // Try to write a test document
      await FirebaseFirestore.instance
          .collection('numerology_result')
          .doc('test_connection')
          .set({'test': true, 'timestamp': FieldValue.serverTimestamp()});

      // Try to read it back
      final doc = await FirebaseFirestore.instance
          .collection('numerology_result')
          .doc('test_connection')
          .get();

      // Clean up test document
      await FirebaseFirestore.instance
          .collection('numerology_result')
          .doc('test_connection')
          .delete();

      debugPrint('✅ Firestore connection test successful');
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Firestore connection test failed: $e');
      return false;
    }
  }
}
