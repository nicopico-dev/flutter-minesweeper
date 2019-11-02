import 'package:flutter/material.dart';
import 'package:minesweeper/cell.dart';

const double CELL_SIZE = 30;

class Minefield extends StatelessWidget {
  final int width;
  final int height;
  final List<CellData> cellsData;

  Minefield({
    @required this.width,
    @required this.height,
    @required this.cellsData,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    for (int row = 0; row < height; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < width; col++) {
        int i = row * col;
        cells.add(
          TableCell(child: MineCell(cellsData[i])),
        );
      }
      rows.add(TableRow(children: cells));
    }
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: FixedColumnWidth(CELL_SIZE),
      children: rows,
    );
  }
}

class MineCell extends StatelessWidget {
  final CellData cellData;

  MineCell(this.cellData);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CELL_SIZE,
      width: CELL_SIZE,
      child: Center(
        child: Text(
          cellData.bomb ? "X" : "",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
