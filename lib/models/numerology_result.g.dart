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
      driverNumber: fields[8] as int,
      destinyNumber: fields[9] as int,
      loshuGrid: (fields[10] as Map).cast<int, int>(),
      missingNumbers: (fields[11] as List).cast<int>(),
      magicalNumbers: (fields[12] as List).cast<int>(),
      firstNameNumber: fields[13] as int,
      fullNameNumber: fields[14] as int,
      personalYear: fields[15] as int,
      personalMonth: fields[16] as int,
      personalDay: fields[17] as int,
      nameCompatibility: (fields[18] as Map).cast<String, dynamic>(),
      driverDestinyMeaning: fields[19] as String,
      planetaryRuler: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NumerologyResult obj) {
    writer
      ..writeByte(21)
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
      ..write(obj.calculatedAt)
      ..writeByte(8)
      ..write(obj.driverNumber)
      ..writeByte(9)
      ..write(obj.destinyNumber)
      ..writeByte(10)
      ..write(obj.loshuGrid)
      ..writeByte(11)
      ..write(obj.missingNumbers)
      ..writeByte(12)
      ..write(obj.magicalNumbers)
      ..writeByte(13)
      ..write(obj.firstNameNumber)
      ..writeByte(14)
      ..write(obj.fullNameNumber)
      ..writeByte(15)
      ..write(obj.personalYear)
      ..writeByte(16)
      ..write(obj.personalMonth)
      ..writeByte(17)
      ..write(obj.personalDay)
      ..writeByte(18)
      ..write(obj.nameCompatibility)
      ..writeByte(19)
      ..write(obj.driverDestinyMeaning)
      ..writeByte(20)
      ..write(obj.planetaryRuler);
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

class CompatibilityResultAdapter extends TypeAdapter<CompatibilityResult> {
  @override
  final int typeId = 3;

  @override
  CompatibilityResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompatibilityResult(
      person1Name: fields[0] as String,
      person2Name: fields[1] as String,
      person1Driver: fields[2] as int,
      person1Destiny: fields[3] as int,
      person2Driver: fields[4] as int,
      person2Destiny: fields[5] as int,
      driverCompatibility: fields[6] as String,
      destinyCompatibility: fields[7] as String,
      overallRating: fields[8] as String,
      calculatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CompatibilityResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.person1Name)
      ..writeByte(1)
      ..write(obj.person2Name)
      ..writeByte(2)
      ..write(obj.person1Driver)
      ..writeByte(3)
      ..write(obj.person1Destiny)
      ..writeByte(4)
      ..write(obj.person2Driver)
      ..writeByte(5)
      ..write(obj.person2Destiny)
      ..writeByte(6)
      ..write(obj.driverCompatibility)
      ..writeByte(7)
      ..write(obj.destinyCompatibility)
      ..writeByte(8)
      ..write(obj.overallRating)
      ..writeByte(9)
      ..write(obj.calculatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompatibilityResultAdapter &&
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
        return NumerologyType.lifePathNumber;
      case 1:
        return NumerologyType.birthdayNumber;
      case 2:
        return NumerologyType.expressionNumber;
      case 3:
        return NumerologyType.soulUrgeNumber;
      case 4:
        return NumerologyType.personalityNumber;
      case 5:
        return NumerologyType.driverNumber;
      case 6:
        return NumerologyType.destinyNumber;
      case 7:
        return NumerologyType.firstNameNumber;
      case 8:
        return NumerologyType.fullNameNumber;
      default:
        return NumerologyType.lifePathNumber;
    }
  }

  @override
  void write(BinaryWriter writer, NumerologyType obj) {
    switch (obj) {
      case NumerologyType.lifePathNumber:
        writer.writeByte(0);
        break;
      case NumerologyType.birthdayNumber:
        writer.writeByte(1);
        break;
      case NumerologyType.expressionNumber:
        writer.writeByte(2);
        break;
      case NumerologyType.soulUrgeNumber:
        writer.writeByte(3);
        break;
      case NumerologyType.personalityNumber:
        writer.writeByte(4);
        break;
      case NumerologyType.driverNumber:
        writer.writeByte(5);
        break;
      case NumerologyType.destinyNumber:
        writer.writeByte(6);
        break;
      case NumerologyType.firstNameNumber:
        writer.writeByte(7);
        break;
      case NumerologyType.fullNameNumber:
        writer.writeByte(8);
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
