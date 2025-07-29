import 'package:flutter/material.dart';
import '../widgets/circular_schedule_painter.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String date;
  final List<String> tasks;
  final TimeOfDay wakeUpTime;
  final int sleepHour;

  const HistoryDetailScreen({
    super.key,
    required this.date,
    required this.tasks,
    required this.wakeUpTime,
    required this.sleepHour,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$date 기록')),
      body: Center(
        child: CustomPaint(
          size: const Size(300, 300),
          painter: CircularSchedulePainter(
            tasks: tasks,
            wakeUpTime: wakeUpTime,
            sleepHour: sleepHour,
          ),
        ),
      ),
    );
  }
}
