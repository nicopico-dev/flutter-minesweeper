import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:provider/provider.dart';

class GameStatusText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      switch (game.status) {
        case GameStatus.Win:
          return Text("You win !!!");
          break;
        case GameStatus.Lose:
          return Text("BOOM! You lose...");
          break;
        case GameStatus.Play:
        default:
          return Text("");
          break;
      }
    });
  }
}
