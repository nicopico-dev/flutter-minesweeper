import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:provider/provider.dart';

import 'game_status_text.dart';
import 'minefield/minefield.dart';
import 'smiley_face.dart';

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
              SmileyButton(),
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
