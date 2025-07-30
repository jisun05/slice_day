import 'package:hive/hive.dart';
import '../models/record_model.dart';

class RecordService {
  final String _boxName = 'recordBox';

  Future<void> saveRecordModel(RecordModel record) async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    await box.put(record.date, record); // 🔹 날짜를 key로 저장
  }

  Future<RecordModel?> getRecordByDate(String date) async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    return box.get(date);
  }

  Future<List<RecordModel>> getAllRecords() async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    return box.values.toList();
  }

  Future<void> deleteRecord(String date) async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    await box.delete(date);
  }

  Future<void> clearAllRecords() async {
    final box = await Hive.openBox<RecordModel>(_boxName);
    await box.clear();
  }
}
