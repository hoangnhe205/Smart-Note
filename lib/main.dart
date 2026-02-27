import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'note_home_page.dart'; // Đảm bảo import đúng

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final appProvider = AppProvider();
  await appProvider.initData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Note',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      // ĐẶT TRỰC TIẾP TRANG CHỦ LÀ NOTE HOME PAGE
      home: const NoteHomePage(),
    );
  }
}
