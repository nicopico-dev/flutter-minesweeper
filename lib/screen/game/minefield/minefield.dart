import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:provider/provider.dart';

import 'cell_content.dart';
import 'mine_cell.dart';

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
