// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordModelAdapter extends TypeAdapter<RecordModel> {
  @override
  final int typeId = 0;

  @override
  RecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecordModel(
      date: fields[0] as String,
      tasks: (fields[1] as List).cast<String>(),
      wakeUpHour: fields[2] as int,
      wakeUpMinute: fields[3] as int,
      sleepHour: fields[4] as int,
      sleepMinute: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.tasks)
      ..writeByte(2)
      ..write(obj.wakeUpHour)
      ..writeByte(3)
      ..write(obj.wakeUpMinute)
      ..writeByte(4)
      ..write(obj.sleepHour)
      ..writeByte(5)
      ..write(obj.sleepMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
