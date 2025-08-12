import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 0)
class UserData extends Equatable {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final DateTime dateOfBirth;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String selectedSystem;

  const UserData({
    required this.fullName,
    required this.dateOfBirth,
    required this.createdAt,
    required this.email,
    this.selectedSystem = 'both',
  });

  UserData copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    String? email,
    String? selectedSystem,
  }) {
    return UserData(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
      selectedSystem: selectedSystem ?? this.selectedSystem,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    dateOfBirth,
    createdAt,
    email,
    selectedSystem,
  ];

  @override
  String toString() {
    return 'UserData(fullName: $fullName, dateOfBirth: $dateOfBirth, createdAt: $createdAt, email: $email, selectedSystem: $selectedSystem)';
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'email': email,
      'selectedSystem': selectedSystem,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fullName: json['fullName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      email: json['email'] as String,
      selectedSystem: json['selectedSystem'] as String? ?? 'both',
    );
  }
}
