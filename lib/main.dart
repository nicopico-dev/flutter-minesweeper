import 'package:flutter/material.dart';
import 'package:minesweeper/domain/difficulty_state.dart';
import 'package:minesweeper/screen/game/game_screen.dart';
import 'package:provider/provider.dart';

import 'domain/game_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DifficultyState>(
      create: (_) => DifficultyState(),
      child: ChangeNotifierProxyProvider<DifficultyState, GameState>(
        create: (context) {
          var difficulty =
              Provider.of<DifficultyState>(context, listen: false).difficulty;
          return GameState(difficulty: difficulty);
        },
        update: (_, difficultyState, gameState) =>
            gameState..difficulty = difficultyState.difficulty,
        child: MaterialApp(
          title: 'Minesweeper Demo',
          home: GameScreen(),
        ),
      ),
    );
  }
}
