import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/cell.dart';

class Minefield extends StatefulWidget {
  final int width;
  final int height;
  final double bombPercent;

  Minefield({
    @required this.width,
    @required this.height,
    this.bombPercent = 0.15,
  });

  @override
  _MinefieldState createState() => _MinefieldState();
}

class _MinefieldState extends State<Minefield> {
  static const double cellSize = 30;
  List<CellData> _cells;

  @override
  void initState() {
    super.initState();
    this._cells = _plantBombs(widget.width * widget.height, widget.bombPercent);
  }

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    for (int row = 0; row < widget.height; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < widget.width; col++) {
        int i = row * col;
        cells.add(
          TableCell(
            child: Container(
              height: cellSize,
              child: Center(
                child: Text(_cells[i].bomb ? "X" : ""),
              ),
            ),
          ),
        );
      }
      rows.add(TableRow(children: cells));
    }
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: FixedColumnWidth(cellSize),
      children: rows,
    );
  }
}

List<CellData> _plantBombs(int length, double bombPercent) {
  var bombsLeft = length * bombPercent;
  var cellsLeft = length;

  final cellIndexes = List<int>.generate(length, (i) => i)..shuffle();

  final cells = List<CellData>(length);
  for (var i in cellIndexes) {
    double r = Random().nextDouble();
    double bombProbability = bombsLeft / cellsLeft;
    bool hasBomb = r <= bombProbability;
    cells[i] = CellData(bomb: hasBomb);

    cellsLeft -= 1;
    if (hasBomb) bombsLeft -= 1;
  }

  return cells;
}
