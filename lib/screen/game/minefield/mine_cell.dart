import 'package:flutter/material.dart';
import 'package:minesweeper/domain/cell_data.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:provider/provider.dart';

import 'cell_content.dart';

class MineCell extends StatelessWidget {
  final int index;
  final CellData data;

  const MineCell({Key key, @required this.index, @required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameState game = Provider.of<GameState>(context, listen: false);
    CellData cellData = data;

    bool isCovered = cellData.state == CellState.covered;
    bool isMarked = cellData.state == CellState.marked;
    bool canPlay = (isCovered || isMarked) && game.status == GameStatus.Play;

    return Container(
      width: CELL_SIZE,
      height: CELL_SIZE,
      child: CellContent(
        cellData: cellData,
        gameStatus: game.status,
        onTap: canPlay && !isMarked ? () => game.uncover(index) : null,
        onLongPress: canPlay ? () => game.toggleMark(index) : null,
      ),
    );
  }
}
