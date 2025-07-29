import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/record_service.dart';
import '../widgets/circular_schedule_painter.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final RecordService recordService;

  const HomeScreen({super.key, required this.recordService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? wakeUpTime;
  final TextEditingController taskController = TextEditingController();
  int blockCount = 4;
  List<String> blocks = List.filled(4, '');
  int sleepHour = 23;

  void _startDay() {
    setState(() {
      wakeUpTime = TimeOfDay.now();
    });
  }

  void _submitTask() {
    if (wakeUpTime == null || taskController.text.isEmpty) return;

    final now = TimeOfDay.now();
    final startHour = wakeUpTime!.hour;
    final nowDecimal = now.hour + now.minute / 60;
    final startDecimal = startHour.toDouble();
    final totalHours = (sleepHour >= startHour)
        ? sleepHour - startHour
        : 24 - startHour + sleepHour;

    if (totalHours <= 0) return;

    final blockSize = totalHours / blockCount;
    final elapsed = (nowDecimal < startDecimal)
        ? nowDecimal + 24 - startDecimal
        : nowDecimal - startDecimal;
    int blockIndex = (elapsed / blockSize).floor();

    if (blockIndex < 0) blockIndex = 0;
    if (blockIndex >= blockCount) blockIndex = blockCount - 1;

    setState(() {
      blocks[blockIndex] = blocks[blockIndex].isEmpty
          ? taskController.text
          : '${blocks[blockIndex]}, ${taskController.text}';
      taskController.clear();
    });

    // ✅ 저장
    final today = DateTime.now().toIso8601String().split('T').first;
    final record = RecordModel(
      date: today,
      tasks: blocks,
      wakeUpHour: wakeUpTime!.hour,
      sleepHour: sleepHour,
    );

    widget.recordService.saveRecordModel(record);
  }

  void _changeBlockCount(int count) {
    setState(() {
      blockCount = count;
      blocks = List.filled(count, '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final wakeUpText =
    wakeUpTime != null ? '기상 시간: ${wakeUpTime!.format(context)}' : 'START';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slice Day Clock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(recordService: widget.recordService),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startDay,
              child: Text(wakeUpText),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('블록 수: '),
                ChoiceChip(
                  label: const Text('3등분'),
                  selected: blockCount == 3,
                  onSelected: (_) => _changeBlockCount(3),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('4등분'),
                  selected: blockCount == 4,
                  onSelected: (_) => _changeBlockCount(4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: '업무 내용 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('제출'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: CircularSchedulePainter(
                  tasks: blocks,
                  wakeUpTime: wakeUpTime,
                  sleepHour: sleepHour,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
