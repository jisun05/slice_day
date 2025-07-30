import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/record_model.dart';
import 'services/record_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecordModelAdapter());
  await Hive.openBox('records');
  await Hive.openBox('settings'); // settingsBox 추가

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final recordService = RecordService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slice Day Clock',
      home: HomeScreen(recordService: recordService),
    );
  }
}
