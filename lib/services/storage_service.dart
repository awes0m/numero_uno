import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_data.dart';
import '../models/numerology_result.dart';

class StorageService {
  static const String _userInputBoxName = 'user_inputs';
  static const String _numerologyResultBoxName = 'numerology_results';
  static const String _lastCalculationKey = 'last_calculation';

  late Box<UserData> _userInputBox;
  late Box<NumerologyResult> _numerologyResultBox;
  late SharedPreferences _prefs;

  /// Initialize storage service
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserDataAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NumerologyResultAdapter());
    }

    // Open boxes
    _userInputBox = await Hive.openBox<UserData>(_userInputBoxName);
    _numerologyResultBox = await Hive.openBox<NumerologyResult>(
      _numerologyResultBoxName,
    );

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
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
          .doc(userId)
          .collection('inputs')
          .add(userInput.toJson());
    } else {
      final key = 'anonymous_${userInput.createdAt.millisecondsSinceEpoch}';
      await _userInputBox.put(key, userInput);
    }
  }

  /// Get all user inputs
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
          .doc(userId)
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

  /// Get numerology results
  List<NumerologyResult> getNumerologyResults() {
    return _numerologyResultBox.values.toList()
      ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
  }

  /// Get numerology result from Firestore by unique user ID (email)
  Future<NumerologyResult?> getNumerologyResultByUserId(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('numerology_results')
        .doc(userId.toLowerCase())
        .get();
    if (doc.exists) {
      return NumerologyResult.fromJson(doc.data()!);
    }
    return null;
  }

  /// Get numerology result from Firestore by name (case-insensitive)
  Future<NumerologyResult?> getNumerologyResultFromFirestoreByName(
    String name,
  ) async {
    final query = await FirebaseFirestore.instance
        .collection('numerology_results')
        .where('fullNameLower', isEqualTo: name.toLowerCase())
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return NumerologyResult.fromJson(query.docs.first.data());
    }
    return null;
  }

  /// Save numerology result to Firestore by user ID (email)
  Future<void> saveNumerologyResultToFirestore(
    NumerologyResult result,
    String userId,
  ) async {
    await FirebaseFirestore.instance
        .collection('numerology_results')
        .doc(userId.toLowerCase())
        .set({
          ...result.toJson(),
          'userId': userId.toLowerCase(),
          'fullNameLower': result.fullName.toLowerCase(),
        });
  }

  /// Save numerology result to Firestore by name (legacy method - for backwards compatibility)
  Future<void> saveNumerologyResultToFirestoreByName(
    NumerologyResult result,
  ) async {
    await FirebaseFirestore.instance
        .collection('numerology_results')
        .doc(result.fullName.toLowerCase())
        .set({
          ...result.toJson(),
          'fullNameLower': result.fullName.toLowerCase(),
        });
  }

  /// Get last calculation
  NumerologyResult? getLastCalculation() {
    final lastKey = _prefs.getString(_lastCalculationKey);
    if (lastKey != null) {
      return _numerologyResultBox.get(lastKey);
    }
    return null;
  }

  /// Clear all data
  Future<void> clearAllData() async {
    await _userInputBox.clear();
    await _numerologyResultBox.clear();
    await _prefs.clear();
  }

  /// Get storage statistics
  Map<String, int> getStorageStats() {
    return {
      'userInputs': _userInputBox.length,
      'numerologyResults': _numerologyResultBox.length,
    };
  }

  /// Close storage
  Future<void> close() async {
    await _userInputBox.close();
    await _numerologyResultBox.close();
  }
}
