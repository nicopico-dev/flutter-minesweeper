import 'package:flutter/material.dart';

import 'cell_data.dart';
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
  final int _width = 10;
  final int _height = 10;
  final double _bombPercent = 0.15;
  List<CellData> _cellsData;

  @override
  void initState() {
    super.initState();
    this._initialize();
  }

  void _initialize() {
    this._cellsData = plantBombs(_width * _height, _bombPercent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Restart"),
              onPressed: this.restart,
            ),
            SizedBox(height: 16),
            Minefield(
              width: _width,
              height: _height,
              cellsData: _cellsData,
            ),
          ],
        ),
      ),
    );
  }

  void restart() {
    setState(() {
      this._initialize();
    });
  }
}
