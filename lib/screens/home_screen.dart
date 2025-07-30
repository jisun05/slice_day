import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/record_service.dart';
import '../widgets/circular_schedule_painter.dart';
import 'history_screen.dart';
import 'dart:async'; // 🔹 추가: Timer 사용을 위해

class HomeScreen extends StatefulWidget {
  final RecordService recordService;

  const HomeScreen({super.key, required this.recordService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? wakeUpTime;
  TimeOfDay sleepTime = const TimeOfDay(hour: 23, minute: 0);
  final TextEditingController taskController = TextEditingController();
  int blockCount = 4;
  List<String> blocks = List.filled(4, '');

  Timer? _checkTimer; // 🔹 추가: 반복 체크용 타이머

  @override
  void initState() {
    super.initState();
    _checkResetWakeUpTime(); // 🔹 최초 진입 시 체크
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkResetWakeUpTime(); // 🔹 1분마다 자동 체크
    });
  }

  @override
  void dispose() {
    _checkTimer?.cancel(); // 🔹 타이머 해제
    super.dispose();
  }

  // 🔹 기상 시간 초기화 로직
  void _checkResetWakeUpTime() {
    if (wakeUpTime == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final wakeUpDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      wakeUpTime!.hour,
      wakeUpTime!.minute,
    );

    DateTime sleepDateTime = DateTime(
      today.year,
      today.month,
      today.day,
      sleepTime.hour,
      sleepTime.minute,
    );

    // 기상 시간이 취침 시간보다 나중일 경우, 취침은 다음 날로 설정
    if (sleepTime.hour < wakeUpTime!.hour ||
        (sleepTime.hour == wakeUpTime!.hour &&
            sleepTime.minute < wakeUpTime!.minute)) {
      sleepDateTime = sleepDateTime.add(const Duration(days: 1));
    }

    if (now.isAfter(sleepDateTime)) {
      setState(() {
        wakeUpTime = null;
        blocks = List.filled(blockCount, ''); // 🔹 블록도 초기화
      });
    }
  }

  void _startDay() {
    if (wakeUpTime != null) return; // 🔹 이미 설정되어 있으면 무시
    setState(() {
      wakeUpTime = TimeOfDay.now();
    });
  }

  void _submitTask() {
    if (wakeUpTime == null || taskController.text.isEmpty) return;

    final now = TimeOfDay.now();
    final startDecimal = wakeUpTime!.hour + wakeUpTime!.minute / 60.0;
    final nowDecimal = now.hour + now.minute / 60.0;
    final sleepDecimal = sleepTime.hour + sleepTime.minute / 60.0;

    final totalHours = (sleepDecimal >= startDecimal)
        ? sleepDecimal - startDecimal
        : 24 - startDecimal + sleepDecimal;

    if (totalHours <= 0) return;

    final blockSize = totalHours / blockCount;
    final elapsed = (nowDecimal < startDecimal)
        ? nowDecimal + 24 - startDecimal
        : nowDecimal - startDecimal;
    int blockIndex = (elapsed / blockSize).floor();

    if (blockIndex < 0) blockIndex = 0;
    if (blockIndex >= blockCount) blockIndex = blockCount - 1;

    final currentTasks = blocks[blockIndex]
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (currentTasks.length >= 6) {
      // 최대 6개 제한
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('한 블록당 최대 6개의 업무만 입력할 수 있어요.')),
      );
      return;
    }

    setState(() {
      blocks[blockIndex] = blocks[blockIndex].isEmpty
          ? taskController.text
          : '${blocks[blockIndex]}, ${taskController.text}';
      taskController.clear();
    });


    final today = DateTime.now().toIso8601String().split('T').first;
    final record = RecordModel(
      date: today,
      tasks: blocks,
      wakeUpHour: wakeUpTime!.hour,
      wakeUpMinute: wakeUpTime!.minute,
      sleepTime: sleepTime.hour,
      sleepMinute: sleepTime.minute,
    );

    widget.recordService.saveRecordModel(record);
  }

  void _changeBlockCount(int count) {
    if (wakeUpTime == null) return;

    final oldBlockCount = blockCount;
    final oldBlocks = blocks;
    final startDecimal = wakeUpTime!.hour + wakeUpTime!.minute / 60.0;
    final sleepDecimal = sleepTime.hour + sleepTime.minute / 60.0;
    final totalHours = (sleepDecimal >= startDecimal)
        ? sleepDecimal - startDecimal
        : 24 - startDecimal + sleepDecimal;

    List<String> newBlocks = List.filled(count, '');

    for (int i = 0; i < oldBlockCount; i++) {
      if (oldBlocks[i].isEmpty) continue;

      final oldBlockStart = startDecimal + i * totalHours / oldBlockCount;
      final blockMid = oldBlockStart + totalHours / oldBlockCount / 2;
      final normalizedMid = blockMid % 24;

      final newIndex =
      ((normalizedMid - startDecimal + 24) % 24 / totalHours * count)
          .floor();
      final clampedIndex = newIndex.clamp(0, count - 1);

      newBlocks[clampedIndex] = newBlocks[clampedIndex].isEmpty
          ? oldBlocks[i]
          : '${newBlocks[clampedIndex]}, ${oldBlocks[i]}';
    }

    setState(() {
      blockCount = count;
      blocks = newBlocks;
    });
  }

  void _selectSleepTime() async {
    int selectedHour = sleepTime.hour;
    int selectedMinute = sleepTime.minute;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('취침 시간 설정'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: selectedHour,
                    items: List.generate(24, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('$index시'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedHour = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<int>(
                    value: selectedMinute,
                    items: List.generate(60, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('$index분'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedMinute = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  sleepTime = TimeOfDay(
                    hour: selectedHour,
                    minute: selectedMinute,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
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
            icon: const Icon(Icons.nightlight_round),
            tooltip: '취침시간 설정',
            onPressed: _selectSleepTime,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HistoryScreen(recordService: widget.recordService),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: wakeUpTime == null ? _startDay : null, // 🔹 이미 설정됐으면 null로 비활성화
              style: ButtonStyle(
                mouseCursor: MaterialStateProperty.resolveWith((states) {
                  if (wakeUpTime != null) {
                    return SystemMouseCursors.basic; // 🔹 클릭 불가능한 커서
                  } else {
                    return SystemMouseCursors.click; // 🔹 클릭 가능할 때만 손모양 커서
                  }
                }),
              ),
              child: Text(wakeUpTime != null
                  ? '기상 시간: ${wakeUpTime!.format(context)}'
                  : 'START'),
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
                  sleepTime: sleepTime,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
