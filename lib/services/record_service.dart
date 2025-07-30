import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/record_model.dart';

class RecordService {
  final String boxName = 'daily_records';

  Future<void> saveRecordModel(RecordModel model) async {
    final box = await Hive.openBox<RecordModel>(boxName);
    box.put(model.date, model);
  }

  Future<List<RecordModel>> getAllRecords() async {
    final box = await Hive.openBox<RecordModel>(boxName);
    return box.values.toList();
  }

  Future<void> deleteRecordByDate(String date) async {
    final box = await Hive.openBox<RecordModel>(boxName);
    await box.delete(date);
  }

  Future<void> saveSleepTime(TimeOfDay time) async {
    final box = await Hive.openBox('settings');
    box.put('sleepHour', time.hour);
    box.put('sleepMinute', time.minute);
  }
  
  Future<TimeOfDay> loadSleepTime() async {
    final box = await Hive.openBox('settings');
    final hour = box.get('sleepHour', defaultValue: 23);
    final minute = box.get('sleepMinute', defaultValue: 0);
    return TimeOfDay(hour: hour, minute: minute);
  }
}