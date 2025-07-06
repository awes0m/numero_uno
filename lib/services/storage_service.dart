import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_input.dart';
import '../models/numerology_result.dart';

class StorageService {
  static const String _userInputBoxName = 'user_inputs';
  static const String _numerologyResultBoxName = 'numerology_results';
  static const String _lastCalculationKey = 'last_calculation';

  late Box<UserInput> _userInputBox;
  late Box<NumerologyResult> _numerologyResultBox;
  late SharedPreferences _prefs;

  /// Initialize storage service
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserInputAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(NumerologyResultAdapter());
    }

    // Open boxes
    _userInputBox = await Hive.openBox<UserInput>(_userInputBoxName);
    _numerologyResultBox = await Hive.openBox<NumerologyResult>(_numerologyResultBoxName);
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save user input
  Future<void> saveUserInput(UserInput userInput) async {
    final key = '${userInput.userId ?? 'anonymous'}_${userInput.createdAt.millisecondsSinceEpoch}';
    await _userInputBox.put(key, userInput);
  }

  /// Get user inputs for a specific user
  List<UserInput> getUserInputs(String? userId) {
    final userKey = userId ?? 'anonymous';
    return _userInputBox.values
        .where((input) => (input.userId ?? 'anonymous') == userKey)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Save numerology result
  Future<void> saveNumerologyResult(NumerologyResult result) async {
    final key = '${result.fullName}_${result.calculatedAt.millisecondsSinceEpoch}';
    await _numerologyResultBox.put(key, result);
    
    // Save as last calculation
    await _prefs.setString(_lastCalculationKey, key);
  }

  /// Get numerology results
  List<NumerologyResult> getNumerologyResults() {
    return _numerologyResultBox.values.toList()
      ..sort((a, b) => b.calculatedAt.compareTo(a.calculatedAt));
  }

  /// Get last calculation
  NumerologyResult? getLastCalculation() {
    final lastKey = _prefs.getString(_lastCalculationKey);
    if (lastKey != null) {
      return _numerologyResultBox.get(lastKey);
    }
    return null;
  }

  /// Clear all user data
  Future<void> clearUserData(String? userId) async {
    final userKey = userId ?? 'anonymous';
    
    // Remove user inputs
    final userInputKeys = _userInputBox.keys
        .where((key) => key.toString().startsWith(userKey))
        .toList();
    
    for (final key in userInputKeys) {
      await _userInputBox.delete(key);
    }

    // Clear last calculation if it was for this user
    final lastKey = _prefs.getString(_lastCalculationKey);
    if (lastKey != null && lastKey.startsWith(userKey)) {
      await _prefs.remove(_lastCalculationKey);
    }
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