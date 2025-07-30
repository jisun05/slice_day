import 'package:flutter/material.dart';
import '../models/record_model.dart';
import '../services/record_service.dart';

class HistoryScreen extends StatefulWidget {
  final RecordService recordService;

  const HistoryScreen({super.key, required this.recordService});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<RecordModel> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords(); // async 함수 호출
  }

  Future<void> _loadRecords() async {
    records = await widget.recordService.getAllRecords();
    setState(() {}); // 상태 업데이트로 UI 갱신
  }

  void _deleteRecord(String date) async {
    await widget.recordService.deleteRecord(date); // 메서드 이름 일치
    await _loadRecords(); // 다시 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기록 히스토리')),
      body: records.isEmpty
          ? const Center(child: Text('기록이 없습니다.'))
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          final taskSummary = record.tasks
              .where((t) => t.trim().isNotEmpty)
              .join(" / ");

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(record.date),
              subtitle: Text(taskSummary.isEmpty ? '(업무 없음)' : taskSummary),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteRecord(record.date),
              ),
            ),
          );
        },
      ),
    );
  }
}
