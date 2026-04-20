import 'package:flutter/material.dart';
import 'package:modelhandling/controller/chat_controller.dart';

import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://hfkcarkgxtowulurqolc.supabase.co",
    anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhma2NhcmtneHRvd3VsdXJxb2xjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4MDU5MjMsImV4cCI6MjA5MDM4MTkyM30.4YxyzRrwIIu0s-sLSOz-KiqcOTM5UC0tDYEb2X-ZquI",
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Info Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatPage(username: 'Li'),
    );
  }
}