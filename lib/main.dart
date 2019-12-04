import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              SizedBox(height: 16),
              GameStatusText()
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

class GameStatusText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      switch (game.status) {
        case GameStatus.Win:
          return Text("You win !!!");
          break;
        case GameStatus.Lose:
          return Text("You lose...");
          break;
        case GameStatus.Play:
        default:
          return Text("");
          break;
      }
    });
  }
}
