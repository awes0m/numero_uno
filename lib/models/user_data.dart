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

  const UserData({
    required this.fullName,
    required this.dateOfBirth,
    required this.createdAt,
    required this.email,
  });

  UserData copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    String? email,
  }) {
    return UserData(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [fullName, dateOfBirth, createdAt, email];

  @override
  String toString() {
    return 'UserData(fullName: $fullName, dateOfBirth: $dateOfBirth, createdAt: $createdAt, email: $email)';
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'email': email,
    };
  }
}
