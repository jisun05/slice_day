import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/record_service.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final RecordService recordService;

  const HistoryScreen({super.key, required this.recordService});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<RecordModel> records;
  bool isSelectionMode = false;
  Set<String> selectedDates = {};

  @override
  void initState() {
    super.initState();
    records = widget.recordService.getAllRecords();
  }

  void _toggleSelectionMode() {
    if (isSelectionMode && selectedDates.isNotEmpty) {
      // 선택된 기록 삭제
      for (var date in selectedDates) {
        widget.recordService.deleteRecordByDate(date);
      }
      selectedDates.clear();
      records = widget.recordService.getAllRecords();
    }

    setState(() {
      isSelectionMode = !isSelectionMode;
    });
  }

  void _toggleSelect(String date) {
    setState(() {
      if (selectedDates.contains(date)) {
        selectedDates.remove(date);
      } else {
        selectedDates.add(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과거 기록 보기'),
        actions: [
          IconButton(
            icon: Icon(isSelectionMode ? Icons.delete : Icons.delete_outline),
            onPressed: _toggleSelectionMode,
          ),
        ],
      ),
      body: records.isEmpty
          ? const Center(child: Text('저장된 기록이 없습니다.'))
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final isSelected = selectedDates.contains(record.date);

          return ListTile(
            leading: isSelectionMode
                ? Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleSelect(record.date),
            )
                : null,
            title: Text(record.date),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (isSelectionMode) {
                _toggleSelect(record.date);
              } else {
                final wakeUpTime = TimeOfDay(
                  hour: record.wakeUpHour,
                  minute: 0,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryDetailScreen(
                      date: record.date,
                      tasks: record.tasks,
                      wakeUpTime: wakeUpTime,
                      sleepTime: TimeOfDay(hour: record.sleepTime, minute: 0),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
