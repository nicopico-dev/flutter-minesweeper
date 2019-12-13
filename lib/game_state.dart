import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:minesweeper/smiley_face.dart';

import 'cell_data.dart';

enum GameStatus { Play, Win, Lose }

class GameState extends ChangeNotifier {
  final int width;
  final int height;
  final double bombPercent;

  List<CellData> _cellsData = [];
  UnmodifiableListView<CellData> get cellsData =>
      UnmodifiableListView(_cellsData);

  GameStatus _status;
  GameStatus get status => _status;

  SmileyState _smiley = SmileyState.Chilling;
  SmileyState get smiley => _smiley;

  GameState({
    @required this.width,
    @required this.height,
    this.bombPercent = 0.15,
  })  : _cellsData = _initializeCellsData(width, height, bombPercent),
        _status = GameStatus.Play;

  void restart() {
    _cellsData = _initializeCellsData(this.width, this.height, bombPercent);
    _status = GameStatus.Play;
    _smiley = SmileyState.Chilling;
    notifyListeners();
  }

  void uncover(int cellIndex) {
    var cell = _cellsData[cellIndex];
    _cellsData[cellIndex] = cell.withState(CellState.uncovered);

    if (cell.bomb) {
      _status = GameStatus.Lose;
    } else if (_checkVictory()) {
      _status = GameStatus.Win;
    } else if (cell.neighborBombs == 0) {
      _uncoverNeighbors(cellIndex);
    }

    _stress();
    notifyListeners();
  }

  bool _checkVictory() => _cellsData.every(
        (c) => c.state == CellState.uncovered || c.bomb,
      );

  void _uncoverNeighbors(int cellIndex) {
    for (int i in _getNeighborIndexes(cellIndex, this.width, this.cellsData)) {
      final cell = _cellsData[i];
      if (cell.bomb == false && cell.state != CellState.uncovered) {
        _cellsData[i] = cell.withState(CellState.uncovered);
        if (cell.neighborBombs == 0) {
          _uncoverNeighbors(i);
        }
      }
    }
  }

  void toggleMark(int cellIndex) {
    var cell = _cellsData[cellIndex];
    var newState =
        cell.state == CellState.covered ? CellState.marked : CellState.covered;
    _cellsData[cellIndex] = cell.withState(newState);
    notifyListeners();
  }

  void _stress() {
    _smiley = SmileyState.Stressed;
    Future.delayed(Duration(milliseconds: 100)).whenComplete(_updateSmiley);
  }

  void _updateSmiley() {
    switch (status) {
      case GameStatus.Win:
        _smiley = SmileyState.Victorious;
        break;
      case GameStatus.Lose:
        _smiley = SmileyState.Dead;
        break;
      case GameStatus.Play:
      default:
        _smiley = SmileyState.Chilling;
    }
    notifyListeners();
  }
}

_initializeCellsData(int width, int height, double bombPercent) {
  List<CellData> cells = _plantBombs(width * height, bombPercent);
  return cells
      .asMap()
      .map((cellIndex, v) => MapEntry(
          cellIndex,
          CellData(
            state: v.state,
            bomb: v.bomb,
            neighborBombs: _countNeighborBombs(cellIndex, width, cells),
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
        int cellIndex, int fieldWidth, List<CellData> cellsData) =>
    _getNeighborIndexes(cellIndex, fieldWidth, cellsData)
        .where((i) => cellsData[i].bomb)
        .length;

List<int> _getNeighborIndexes(
  int cellIndex,
  int fieldWidth,
  List<CellData> cellsData,
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

  return neighborIndexes;
}
