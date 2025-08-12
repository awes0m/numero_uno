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
      pinnacles: (fields[15] as Map).cast<String, int>(),
      challenges: (fields[16] as Map).cast<String, int>(),
      personalYears: (fields[17] as Map).cast<String, int>(),
      essences: (fields[18] as Map).cast<String, int>(),
      hiddenPassionNumber: fields[19] as int,
      karmicLessons: (fields[20] as List).cast<int>(),
      karmicDebts: (fields[21] as List).cast<int>(),
      nameCompatibility: (fields[22] as Map).cast<String, dynamic>(),
      detailedAnalysis: (fields[23] as Map).cast<String, dynamic>(),
      systemUsed: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NumerologyResult obj) {
    writer
      ..writeByte(25)
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
      ..write(obj.pinnacles)
      ..writeByte(16)
      ..write(obj.challenges)
      ..writeByte(17)
      ..write(obj.personalYears)
      ..writeByte(18)
      ..write(obj.essences)
      ..writeByte(19)
      ..write(obj.hiddenPassionNumber)
      ..writeByte(20)
      ..write(obj.karmicLessons)
      ..writeByte(21)
      ..write(obj.karmicDebts)
      ..writeByte(22)
      ..write(obj.nameCompatibility)
      ..writeByte(23)
      ..write(obj.detailedAnalysis)
      ..writeByte(24)
      ..write(obj.systemUsed);
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
