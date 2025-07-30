import 'package:hive/hive.dart';

part 'record_model.g.dart'; // 자동 생성될 파일

@HiveType(typeId: 0)
class RecordModel extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<String> tasks;

  @HiveField(2)
  int wakeUpHour;

  @HiveField(3)
  int wakeUpMinute;

  @HiveField(4)
  int sleepTime;

  @HiveField(5)
  int sleepMinute;

  RecordModel({
    required this.date,
    required this.tasks,
    required this.wakeUpHour,
    required this.wakeUpMinute,
    required this.sleepTime,
    required this.sleepMinute,
  });

  /// 🔹 Map 형태로 저장 (선택적으로 사용 가능)
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'tasks': tasks,
      'wakeUpHour': wakeUpHour,
      'wakeUpMinute': wakeUpMinute,
      'sleepTime': sleepTime,
      'sleepMinute': sleepMinute,
    };
  }

  /// 🔹 Map → RecordModel 변환
  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      date: map['date'] as String,
      tasks: List<String>.from(map['tasks']),
      wakeUpHour: map['wakeUpHour'] as int,
      wakeUpMinute: map['wakeUpMinute'] as int,
      sleepTime: map['sleepTime'] as int,
      sleepMinute: map['sleepMinute'] as int,
    );
  }
}
