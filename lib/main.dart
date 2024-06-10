import 'package:flutter/material.dart';
import 'package:atma_kitchen_mobile/page/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const LoginView(),
    );
  }
}
