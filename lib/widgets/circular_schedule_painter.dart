import 'package:flutter/material.dart';
import 'dart:math';

class CircularSchedulePainter extends CustomPainter {
  final List<String> tasks;
  final TimeOfDay? wakeUpTime;
  final TimeOfDay sleepTime;

  CircularSchedulePainter({
    required this.tasks,
    required this.wakeUpTime,
    required this.sleepTime,
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
    final sleep = sleepTime.hour + sleepTime.minute / 60.0;

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

    // Draw sleep arc
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

    // Draw awake blocks
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

     //show task list
      if (task.isNotEmpty) {
        final rawItems = task
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        final texts = <String>[];
        for (int j = 0; j < rawItems.length && j < 6; j++) {
          final isLast = j == rawItems.length - 1 || j == 5;
          final item = rawItems[j];
          texts.add(isLast ? item : '$item,');
        }

        final angleMid = startAngle + sweepAngle / 2;
        final baseRadius = (radius + innerRadius) / 2;

        final lineCount = texts.length.clamp(1, 6);
        final spacing = 20.0;
        final startOffset = -(lineCount - 1) / 2 * spacing;

        final sorted = texts
            .asMap()
            .entries
            .toList()
          ..sort((a, b) => a.value.length.compareTo(b.value.length));

        final indexedRadii = List.generate(
          lineCount,
              (i) => baseRadius + startOffset + i * spacing,
        );

        final textWithRadius = List<String>.filled(lineCount, '');
        final radiiWithText = List<double>.filled(lineCount, 0);

        for (int j = 0; j < sorted.length; j++) {
          final idx = sorted[j].key;
          final txt = sorted[j].value;
          textWithRadius[idx] = txt;
          radiiWithText[idx] = indexedRadii[j];
        }

        for (int j = 0; j < lineCount; j++) {
          final displayText = textWithRadius[j].length > 10
              ? textWithRadius[j].substring(0, 10) + '…'
              : textWithRadius[j];

          final dx = center.dx + radiiWithText[j] * cos(angleMid);
          final dy = center.dy + radiiWithText[j] * sin(angleMid);

          final textPainter = TextPainter(
            text: TextSpan(
              text: displayText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();

          canvas.save();
          canvas.translate(dx, dy);

          if (angleMid >= pi / 2 && angleMid <= 3 * pi / 2) {
            canvas.rotate(angleMid - pi / 2);
          } else {
            canvas.rotate(angleMid + pi / 2);
          }

          canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
          textPainter.paint(canvas, Offset.zero);
          canvas.restore();
        }
      }

      _drawTimeLabel(canvas, center, labelRadius, blockStartHour % 24, totalHours);
      _drawTimeLabel(canvas, center, labelRadius, blockEndHour % 24, totalHours);
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
    int h = hour.floor() % 24;
    int m = ((hour - h) * 60).round();

    if (m >= 60) {
      m -= 60;
      h = (h + 1) % 24;
    }

    final hStr = h.toString().padLeft(2, '0');
    final mStr = m.toString().padLeft(2, '0');
    return '$hStr:$mStr';
  }

  @override
  bool shouldRepaint(covariant CircularSchedulePainter oldDelegate) {
    return oldDelegate.tasks != tasks ||
        oldDelegate.wakeUpTime != wakeUpTime ||
        oldDelegate.sleepTime != sleepTime;
  }
}
