import 'package:bingo_app/game_page.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugLogTree());
  runApp(const MyApp());
}

class DebugLogTree extends DebugTree {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B IN GO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GamePage(),
    );
  }
}
