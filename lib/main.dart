import 'package:flutter/material.dart';
import 'package:minesweeper/crash_report.dart';
import 'package:minesweeper/screen/game/game_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    CrashReportHelper.initialize();
    return MaterialApp(
      title: 'Minesweeper',
      home: GameScreen(),
    );
  }
}
