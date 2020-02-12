import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cell_data.dart';
import 'cell_content.dart';
import 'game_state.dart';

const double CELL_SIZE = 30;

class Minefield extends StatelessWidget {
  final int width;
  final int height;

  const Minefield({Key key, @required this.width, @required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      final rows = <TableRow>[];
      for (int row = 0; row < height; row++) {
        final cells = <Widget>[];
        for (int col = 0; col < width; col++) {
          int cellIndex = row * 10 + col;
          final cellData = game.cellsData[cellIndex];
          cells.add(
            TableCell(
              child: MineCell(
                index: cellIndex,
                data: cellData,
              ),
            ),
          );
        }
        rows.add(TableRow(children: cells));
      }
      return Container(
        color: Color(0xFFBDBDBD),
        child: Table(
          border: TableBorder.all(color: Color(0xFFADADAD)),
          defaultColumnWidth: FixedColumnWidth(CELL_SIZE),
          children: rows,
        ),
      );
    });
  }
}

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
