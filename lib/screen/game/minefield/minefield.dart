import 'package:flutter/material.dart';
import 'package:minesweeper/domain/cell_data.dart';

import 'cell_content.dart';
import 'mine_cell.dart';

class Minefield extends StatelessWidget {
  final int width;
  final int height;
  final List<CellData> cellsData;

  const Minefield({
    Key key,
    @required this.width,
    @required this.height,
    @required this.cellsData,
  })  : assert(cellsData.length == width * height),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    for (int row = 0; row < height; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < width; col++) {
        int cellIndex = row * width + col;
        final cellData = cellsData[cellIndex];
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
    return Table(
      border: TableBorder.all(color: Color(0xFFADADAD)),
      defaultColumnWidth: FixedColumnWidth(CELL_SIZE),
      children: rows,
    );
  }
}
