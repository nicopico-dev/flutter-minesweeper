import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/screen/shared/bezel.dart';
import 'package:minesweeper/screen/shared/constants.dart';
import 'package:minesweeper/screen/shared/digital_counter.dart';
import 'package:minesweeper/screen/shared/menu_bar.dart';
import 'package:minesweeper/screen/shared/menu_drawer.dart';
import 'package:minesweeper/screen/shared/scrollable_content.dart';
import 'package:minesweeper/screen/shared/toolbar.dart';
import 'package:minesweeper/screen/shared/widget_ext.dart';
import 'package:provider/provider.dart';

import 'minefield/minefield.dart';
import 'smiley_face.dart';
import 'time_counter.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Toolbar(title: "Minesweeper"),
              MenuBar(),
              Expanded(
                child: Bezel(
                  child: Consumer<GameState>(
                    builder: (context, game, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Bezel.inverse(
                          child: Row(
                            children: <Widget>[
                              DigitalCounter(value: game.unmarkedBombs),
                              Spacer(),
                              SmileyButton(
                                state: game.smiley,
                                onPressed: game.restart,
                              ),
                              Spacer(),
                              TimeCounter(
                                start: game.startTime,
                                playing: game.status == GameStatus.Play,
                              ),
                            ],
                          ).withPadding(Constants.BORDER_SIZE),
                        ),
                        SizedBox(height: Constants.BORDER_SIZE),
                        Expanded(
                          child: Bezel.inverse(
                            child: Center(
                              child: ScrollableContent(
                                child: Minefield(
                                  width: game.width,
                                  height: game.height,
                                  cellsData: game.cellsData,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).withPadding(Constants.BORDER_SIZE),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
