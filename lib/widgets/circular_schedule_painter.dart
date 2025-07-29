import 'package:flutter/material.dart';
import 'dart:math';

class CircularSchedulePainter extends CustomPainter {
  final List<String> tasks;
  final TimeOfDay? wakeUpTime;
  final int sleepHour;

  CircularSchedulePainter({
    required this.tasks,
    required this.wakeUpTime,
    required this.sleepHour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (wakeUpTime == null) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final labelRadius = radius + 15;
    final innerRadius = 30.0;

    const totalHours = 24;
    final wakeUp = wakeUpTime!.hour + wakeUpTime!.minute / 60.0;
    final sleep = sleepHour.toDouble();

    final sleepStart = sleep;
    final sleepEnd = wakeUp < sleep ? wakeUp + 24 : wakeUp;
    final awakeStart = wakeUp;
    final awakeEnd = sleep < wakeUp ? sleep + 24 : sleep;

    final paint = Paint()..style = PaintingStyle.fill;

    final List<Color> blockColors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
    ];

    final sleepSpan = sleepEnd - sleepStart;
    final sleepStartAngle = 2 * pi * (sleepStart / totalHours) - pi / 2;
    final sleepSweepAngle = 2 * pi * (sleepSpan / totalHours);
    final sleepPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        sleepStartAngle,
        sleepSweepAngle,
        false,
      )
      ..close();
    paint.color = Colors.grey.shade300;
    canvas.drawPath(sleepPath, paint);

    final awakeSpan = awakeEnd - awakeStart;
    final blockSpan = awakeSpan / tasks.length;

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final blockStartHour = awakeStart + blockSpan * i;
      final blockEndHour = blockStartHour + blockSpan;
      final startAngle = 2 * pi * (blockStartHour % 24 / totalHours) - pi / 2;
      final sweepAngle = 2 * pi * (blockSpan / totalHours);

      paint.color = blockColors[i % blockColors.length];
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();
      canvas.drawPath(path, paint);

      if (task.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: task,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final angleMid = startAngle + sweepAngle / 2;
        final textRadius = (radius + innerRadius) / 2;
        final offset = Offset(
          center.dx + textRadius * cos(angleMid) - textPainter.width / 2,
          center.dy + textRadius * sin(angleMid) - textPainter.height / 2,
        );
        textPainter.paint(canvas, offset);
      }

      _drawTimeLabel(canvas, center, labelRadius, blockStartHour, totalHours);
      _drawTimeLabel(canvas, center, labelRadius, blockEndHour, totalHours);
    }
  }

  void _drawTimeLabel(Canvas canvas, Offset center, double radius,
      double hour, int totalHours) {
    final angle = 2 * pi * (hour % 24 / totalHours) - pi / 2;
    final label = _formatHour(hour);
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Colors.black, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      center.dx + radius * cos(angle) - textPainter.width / 2,
      center.dy + radius * sin(angle) - textPainter.height / 2,
    );
    textPainter.paint(canvas, offset);
  }

  String _formatHour(double hour) {
    final h = hour.floor() % 24;
    final m = ((hour - h) * 60).round();
    final hStr = h.toString().padLeft(2, '0');
    final mStr = m.toString().padLeft(2, '0');
    return '${hStr}:${mStr}';
  }


  @override
  bool shouldRepaint(covariant CircularSchedulePainter oldDelegate) {
    return oldDelegate.tasks != tasks ||
        oldDelegate.wakeUpTime != wakeUpTime ||
        oldDelegate.sleepHour != sleepHour;
  }
}