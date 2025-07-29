// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/record_model.dart';
import 'screens/home_screen.dart';
import 'services/record_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecordModelAdapter());
  await Hive.openBox<RecordModel>('records');

  final recordService = RecordService();

  runApp(MyApp(recordService: recordService));
}

class MyApp extends StatelessWidget {
  final RecordService recordService;
  const MyApp({super.key, required this.recordService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SliceDay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomeScreen(recordService: recordService),
    );
  }
}
