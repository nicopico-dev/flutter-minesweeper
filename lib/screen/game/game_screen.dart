import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/screen/shared/bezel.dart';
import 'package:minesweeper/screen/shared/menu_bar.dart';
import 'package:minesweeper/screen/shared/toolbar.dart';
import 'package:provider/provider.dart';

import 'bomb_counter.dart';
import 'game_status_text.dart';
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
                child: Padding(
                  padding: const EdgeInsets.all(borderSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Bezel(
                        bezelLightPosition: BezelLightPosition.SouthEast,
                        child: Padding(
                          padding: const EdgeInsets.all(borderSize),
                          child: Row(
                            children: <Widget>[
                              BombCounter(),
                              Spacer(),
                              SmileyButton(),
                              Spacer(),
                              TimeCounter(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: borderSize),
                      Expanded(
                        child: Bezel(
                          bezelLightPosition: BezelLightPosition.SouthEast,
                          child: Padding(
                            padding: const EdgeInsets.all(borderSize),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Minefield(width: width, height: height),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: borderSize),
                      Center(child: GameStatusText()),
                      SizedBox(height: borderSize),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
