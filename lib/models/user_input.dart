import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_input.g.dart';

@HiveType(typeId: 0)
class UserInput extends Equatable {
  @HiveField(0)
  final String fullName;
  
  @HiveField(1)
  final DateTime dateOfBirth;
  
  @HiveField(2)
  final String? userId; // For Firebase authentication
  
  @HiveField(3)
  final DateTime createdAt;

  const UserInput({
    required this.fullName,
    required this.dateOfBirth,
    this.userId,
    required this.createdAt,
  });

  UserInput copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? userId,
    DateTime? createdAt,
  }) {
    return UserInput(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [fullName, dateOfBirth, userId, createdAt];

  @override
  String toString() {
    return 'UserInput(fullName: $fullName, dateOfBirth: $dateOfBirth, userId: $userId, createdAt: $createdAt)';
  }
}