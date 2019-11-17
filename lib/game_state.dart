import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'cell_data.dart';

class GameState extends ChangeNotifier {
  final int width;
  final int height;
  final double bombPercent;

  List<CellData> _cellsData = [];
  UnmodifiableListView<CellData> get cellsData =>
      UnmodifiableListView(_cellsData);

  GameState({
    @required this.width,
    @required this.height,
    this.bombPercent = 0.15,
  }) : _cellsData = _initializeCellsData(width, height, bombPercent);

  void restart() {
    _cellsData = _initializeCellsData(this.width, this.height, bombPercent);
    notifyListeners();
  }

  void uncover(int cellIndex) {
    var cell = _cellsData[cellIndex];
    _cellsData[cellIndex] = cell.withState(CellState.uncovered);
    notifyListeners();
  }

  void mark(int cellIndex) {
    var cell = _cellsData[cellIndex];
    _cellsData[cellIndex] = cell.withState(CellState.flagged);
    notifyListeners();
  }
}

_initializeCellsData(int width, int height, double bombPercent) {
  List<CellData> cells = _plantBombs(width * height, bombPercent);
  return cells
      .asMap()
      .map((index, v) => MapEntry(
          index,
          CellData(
            state: v.state,
            bomb: v.bomb,
            neighborBombs: _countNeighborBombs(width, cells, index),
          )))
      .values
      .toList();
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

int _countNeighborBombs(
    int fieldWidth, List<CellData> cellsData, int cellIndex) {
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
