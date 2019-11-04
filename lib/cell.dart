import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CellData {
  final bool bomb;
  final CellState state;

  CellData({@required this.bomb, this.state = CellState.covered});
}

enum CellState { covered, uncovered, flagged }

List<CellData> plantBombs(int length, double bombPercent) {
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

int countNeighborBombs(
  int fieldWidth,
  List<CellData> cellsData,
  int cellIndex,
) {
  final int row = (cellIndex / 10).floor();
  final int col = cellIndex - (row * 10);

  final rightMost = fieldWidth - 1;
  final bottomMost = (cellsData.length / fieldWidth) - 1;

  List<int> neighborIndexes = [];
  if (row > 0) {
    if (col > 0) neighborIndexes.add(cellIndex - 11); // top-left
    neighborIndexes.add(cellIndex - 10); // top-center
    if (col < rightMost) neighborIndexes.add(cellIndex - 9); // top-right
  }
  if (col > 0) neighborIndexes.add(cellIndex - 1); // left
  if (col < rightMost) neighborIndexes.add(cellIndex + 1); // right
  if (row < bottomMost) {
    if (col > 0) neighborIndexes.add(cellIndex + 9); // bottom-left
    neighborIndexes.add(cellIndex + 10); // bottom-center
    if (col < rightMost) neighborIndexes.add(cellIndex + 11); // bottom-right
  }

  return neighborIndexes.where((i) => cellsData[i].bomb).length;
}
