import 'package:flutter/material.dart';

import 'minefield.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper Demo',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _dirty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Restart"),
            onPressed: _restart,
          ),
          SizedBox(height: 16),
          Minefield(width: 10, height: 10),
        ],
      ),
    );
  }

  void _restart() {
    // TODO
  }
}
