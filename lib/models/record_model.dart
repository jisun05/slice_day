import 'package:hive/hive.dart';

part 'record_model.g.dart';

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

  Map<String, dynamic> toMap() => {
    'date': date,
    'tasks': tasks,
    'wakeUpHour': wakeUpHour,
    'wakeUpMinute': wakeUpMinute,
    'sleepTime': sleepTime,
    'sleepMinute': sleepMinute,
  };

  factory RecordModel.fromMap(Map<String, dynamic> map) => RecordModel(
    date: map['date'],
    tasks: List<String>.from(map['tasks']),
    wakeUpHour: map['wakeUpHour'],
    wakeUpMinute: map['wakeUpMinute'],
    sleepTime: map['sleepTime'],
    sleepMinute: map['sleepMinute'],
  );
}