// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'numerology_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NumerologyResultAdapter extends TypeAdapter<NumerologyResult> {
  @override
  final int typeId = 1;

  @override
  NumerologyResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NumerologyResult(
      lifePathNumber: fields[0] as int,
      birthdayNumber: fields[1] as int,
      expressionNumber: fields[2] as int,
      soulUrgeNumber: fields[3] as int,
      personalityNumber: fields[4] as int,
      fullName: fields[5] as String,
      dateOfBirth: fields[6] as DateTime,
      calculatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NumerologyResult obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.lifePathNumber)
      ..writeByte(1)
      ..write(obj.birthdayNumber)
      ..writeByte(2)
      ..write(obj.expressionNumber)
      ..writeByte(3)
      ..write(obj.soulUrgeNumber)
      ..writeByte(4)
      ..write(obj.personalityNumber)
      ..writeByte(5)
      ..write(obj.fullName)
      ..writeByte(6)
      ..write(obj.dateOfBirth)
      ..writeByte(7)
      ..write(obj.calculatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumerologyResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NumerologyTypeAdapter extends TypeAdapter<NumerologyType> {
  @override
  final int typeId = 2;

  @override
  NumerologyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NumerologyType.lifePath;
      case 1:
        return NumerologyType.birthday;
      case 2:
        return NumerologyType.expression;
      case 3:
        return NumerologyType.soulUrge;
      case 4:
        return NumerologyType.personality;
      default:
        return NumerologyType.lifePath;
    }
  }

  @override
  void write(BinaryWriter writer, NumerologyType obj) {
    switch (obj) {
      case NumerologyType.lifePath:
        writer.writeByte(0);
        break;
      case NumerologyType.birthday:
        writer.writeByte(1);
        break;
      case NumerologyType.expression:
        writer.writeByte(2);
        break;
      case NumerologyType.soulUrge:
        writer.writeByte(3);
        break;
      case NumerologyType.personality:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumerologyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
