import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/screen/shared/digital_counter.dart';
import 'package:provider/provider.dart';

class BombCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      return DigitalCounter(value: game.markCounter);
    });
  }
}
