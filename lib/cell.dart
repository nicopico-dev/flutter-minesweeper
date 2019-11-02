import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CellData {
  final bool bomb;
  final CellState state;

  CellData({@required this.bomb, this.state = CellState.covered});
}

enum CellState { covered, uncovered, marked }

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
