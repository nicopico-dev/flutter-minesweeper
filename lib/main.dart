import 'package:flutter/material.dart';
import 'package:minesweeper/domain/difficulty_state.dart';
import 'package:minesweeper/screen/game/game_screen.dart';
import 'package:minesweeper/service/preferences.dart';
import 'package:provider/provider.dart';

import 'domain/game_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DifficultyState>(
      create: (_) => DifficultyState(preferences: Preferences()),
      child: ChangeNotifierProxyProvider<DifficultyState, GameState>(
        create: (context) {
          var state = Provider.of<DifficultyState>(context, listen: false);
          return GameState(difficulty: state.difficulty);
        },
        update: (_, difficultyState, gameState) {
          return gameState..difficulty = difficultyState.difficulty;
        },
        child: MaterialApp(
          title: 'Minesweeper Demo',
          home: GameScreen(),
        ),
      ),
    );
  }
}
