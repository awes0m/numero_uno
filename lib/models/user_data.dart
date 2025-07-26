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

  const UserData({
    required this.fullName,
    required this.dateOfBirth,
    required this.createdAt,
  });

  UserData copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) {
    return UserData(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [fullName, dateOfBirth, createdAt];

  @override
  String toString() {
    return 'UserData(fullName: $fullName, dateOfBirth: $dateOfBirth, createdAt: $createdAt)';
  }
}
