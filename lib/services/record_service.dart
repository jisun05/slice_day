import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/record_model.dart';

class RecordService {
  static const _boxName = 'daily_records';
  static const _sleepKey = 'sleep_time';

  Future<void> saveRecordModel(RecordModel record) async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    await box.put(record.date, record);
  }

  Future<List<RecordModel>> getAllRecords() async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteRecordByDate(String date) async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    await box.delete(date);
  }

  Future<void> saveSleepTime(int hour, int minute) async {
    final box = await Hive.openBox(_sleepKey);
    await box.put('hour', hour);
    await box.put('minute', minute);
  }

  Future<TimeOfDay> loadSleepTime() async {
    final box = await Hive.openBox(_sleepKey);
    final hour = box.get('hour', defaultValue: 23);
    final minute = box.get('minute', defaultValue: 0);
    return TimeOfDay(hour: hour, minute: minute);
  }
}