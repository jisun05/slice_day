import 'package:hive/hive.dart';

part 'record_model.g.dart'; // 이 파일은 build_runner로 생성됨

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
  int sleepHour; //

  @HiveField(5)
  int sleepMinute;

  RecordModel({
    required this.date,
    required this.tasks,
    required this.wakeUpHour,
    required this.wakeUpMinute,
    required this.sleepHour,
    required this.sleepMinute,
  });
}


