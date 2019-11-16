import 'package:flutter/material.dart';
import 'package:minesweeper/cell_data.dart';

import 'cell_painter.dart';

class Minefield extends StatelessWidget {
  final int width;
  final int height;
  final List<CellData> cellsData;

  const Minefield({
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
        int cellIndex = row * 10 + col;
        // TODO Defer neighborBomb computation until needed
        int neighborBombs = countNeighborBombs(
          this.width,
          this.cellsData,
          cellIndex,
        );
        cells.add(
          TableCell(
            child: MineCell(this.cellsData[cellIndex], neighborBombs),
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

class MineCell extends StatefulWidget {
  final CellData cellData;
  final int neighborBombs;

  const MineCell(this.cellData, this.neighborBombs);

  @override
  _MineCellState createState() => _MineCellState();
}

class _MineCellState extends State<MineCell> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO Use standard widgets for text and bitmaps
    var cell = CustomPaint(
      size: Size.square(CELL_SIZE),
      painter: CellPainter(widget.cellData, widget.neighborBombs, pressed),
    );

    if (widget.cellData.state == CellState.covered) {
      return GestureDetector(
        onTapDown: this._onPressed,
        onTapUp: this._onPressed,
        onTapCancel: this._onPressed,
        child: cell,
      );
    } else {
      return cell;
    }
  }

  void _onPressed([details]) {
    setState(() {
      this.pressed = details is TapDownDetails;
    });
  }
}
