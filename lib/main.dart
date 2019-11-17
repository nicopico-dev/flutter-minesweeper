import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cell_data.dart';
import 'game_state.dart';
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

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int width = 10;
    final int height = 10;

    return Scaffold(
      body: Center(
        child: ChangeNotifierProvider(
          builder: (context) => GameState(width: width, height: height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RestartButton(),
              SizedBox(height: 16),
              Minefield(width: width, height: height),
            ],
          ),
        ),
      ),
    );
  }
}

class RestartButton extends StatelessWidget {
  const RestartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Restart"),
      onPressed: () => Provider.of<GameState>(context, listen: false).restart(),
    );
  }
}
