import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 나중에 실제 기록 데이터를 불러오도록 수정
    final fakeData = [
      '2025-07-29: 회의, 이메일, 설계',
      '2025-07-28: 개발, 점심, 정리',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('과거 기록')),
      body: ListView.builder(
        itemCount: fakeData.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(fakeData[index]),
          );
        },
      ),
    );
  }
}
