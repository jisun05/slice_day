import 'package:hive/hive.dart';

part 'record_model.g.dart'; // 자동 생성될 파일

@HiveType(typeId: 0)
class RecordModel  extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<String> tasks;

  @HiveField(2)
  int wakeUpHour;

  @HiveField(3)
  int sleepHour;

  RecordModel ({
    required this.date,
    required this.tasks,
    required this.wakeUpHour,
    required this.sleepHour,
  });
}
