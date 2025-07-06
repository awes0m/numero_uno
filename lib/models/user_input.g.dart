// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_input.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInputAdapter extends TypeAdapter<UserInput> {
  @override
  final int typeId = 0;

  @override
  UserInput read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInput(
      fullName: fields[0] as String,
      dateOfBirth: fields[1] as DateTime,
      userId: fields[2] as String?,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserInput obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.dateOfBirth)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInputAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
