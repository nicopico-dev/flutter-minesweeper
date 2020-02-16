import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/screen/shared/bezel.dart';
import 'package:minesweeper/screen/shared/menu_bar.dart';
import 'package:minesweeper/screen/shared/toolbar.dart';
import 'package:minesweeper/screen/shared/widget_ext.dart';
import 'package:provider/provider.dart';

import 'bomb_counter.dart';
import 'minefield/minefield.dart';
import 'smiley_face.dart';
import 'time_counter.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int width = 10;
    final int height = 10;
    const double borderSize = 10;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Toolbar(title: "Minesweeper"),
          MenuBar(),
          Expanded(
            child: Bezel(
              child: ChangeNotifierProvider(
                builder: (context) => GameState(width: width, height: height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Bezel.inverse(
                      child: Row(
                        children: <Widget>[
                          BombCounter(),
                          Spacer(),
                          SmileyButton(),
                          Spacer(),
                          TimeCounter(),
                        ],
                      ).withPadding(borderSize),
                    ),
                    SizedBox(height: borderSize),
                    Expanded(
                      child: Bezel.inverse(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Minefield(width: width, height: height),
                        ).withPadding(borderSize),
                      ),
                    ),
                  ],
                ).withPadding(borderSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
