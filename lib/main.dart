import 'package:flutter/material.dart';
import 'package:atma_kitchen_mobile/page/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: LoginView(),
      ),
    );
  }
}
