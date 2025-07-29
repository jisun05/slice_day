import 'package:hive/hive.dart';
import '../models/record_model.dart';

class RecordService {
  final Box<RecordModel> _box = Hive.box<RecordModel>('records');

  void saveRecordModel(RecordModel model) {
    _box.put(model.date, model);
    _cleanupOldRecords(); //
  }

  RecordModel? getRecordByDate(String date) {
    return _box.get(date);
  }

  void deleteRecordByDate(String date) {
    _box.delete(date);
  }

  List<RecordModel> getAllRecords() {
    // 날짜 기준 내림차순 정렬
    List<RecordModel> sorted = _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  void _cleanupOldRecords() {
    final now = DateTime.now();

    // 날짜가 오래된 순으로 정렬
    final records = _box.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (records.length <= 14) return;

    final excess = records.length - 14;
    for (int i = 0; i < excess; i++) {
      _box.delete(records[i].date); // 오래된 것부터 삭제
    }
  }
}
