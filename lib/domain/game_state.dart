import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:minesweeper/domain/smiley_state.dart';

import 'cell_data.dart';
import 'skill.dart';

enum GameStatus { Play, Win, Lose }

class GameState extends ChangeNotifier {
  Skill _skill = Skill.Beginner;
  Difficulty _difficulty;

  List<CellData> _cellsData;
  GameStatus _status;
  SmileyState _smiley;
  int _gameStart;

  GameState() {
    _startGame();
  }

  void _startGame() {
    _status = GameStatus.Play;
    _smiley = SmileyState.Chilling;
    _gameStart = null;
    _cellsData = List.filled(width * height, CellData(bomb: false));
  }

  Skill get skill => _skill;
  set skill(Skill value) {
    _skill = value;
    _difficulty = value.difficulty;
    _startGame();
    notifyListeners();
  }

  Difficulty get difficulty => _difficulty ?? _skill.difficulty;
  set difficulty(Difficulty value) {
    _skill = Skill.Custom;
    _difficulty = value;
    _startGame();
    notifyListeners();
  }

  int get width => difficulty.width;
  int get height => difficulty.height;

  UnmodifiableListView<CellData> get cellsData =>
      UnmodifiableListView(_cellsData);

  GameStatus get status => _status;

  SmileyState get smiley => _smiley;

  int get startTime => _gameStart;

  int get unmarkedBombs {
    int bombs = difficulty.bombs;
    int marks = 0;
    for (final cell in _cellsData) {
      marks += cell.state == CellState.marked ? 1 : 0;
    }
    return bombs - marks;
  }

  void uncover(int cellIndex) {
    if (_gameStart == null) {
      _gameStart = DateTime.now().millisecondsSinceEpoch;
      _cellsData = _initializeData(cellIndex);
    }

    var cell = _cellsData[cellIndex];
    _cellsData[cellIndex] = cell.withState(CellState.uncovered);

    if (cell.bomb) {
      _status = GameStatus.Lose;
    } else if (_checkVictory()) {
      _status = GameStatus.Win;
    } else if (cell.neighborBombs == 0) {
      _uncoverNeighbors(cellIndex);
      if (_checkVictory()) {
        _status = GameStatus.Win;
      }
    }

    _stress();
    notifyListeners();
  }

  void toggleMark(int cellIndex) {
    var cell = _cellsData[cellIndex];
    var newState =
        cell.state == CellState.covered ? CellState.marked : CellState.covered;

    if (newState == CellState.marked && unmarkedBombs == 0) {
      // TODO Blink the bomb counter
      debugPrint("Too many marks !");
      return;
    }

    _cellsData[cellIndex] = cell.withState(newState);
    notifyListeners();
  }

  void restart() {
    _startGame();
    notifyListeners();
  }

  bool _checkVictory() {
    return _cellsData.every((c) => c.state == CellState.uncovered || c.bomb);
  }

  void _uncoverNeighbors(int cellIndex) {
    for (int i in _getNeighborIndexes(cellIndex)) {
      final cell = _cellsData[i];
      if (cell.bomb == false && cell.state != CellState.uncovered) {
        _cellsData[i] = cell.withState(CellState.uncovered);
        if (cell.neighborBombs == 0) {
          _uncoverNeighbors(i);
        }
      }
    }
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

  /// Place the bombs
  List<CellData> _initializeData(int startingCellIndex) {
    final length = this.difficulty.width * this.difficulty.height;

    final cellIndexes = List<int>.generate(length, (i) => i)
      ..shuffle()
      ..remove(startingCellIndex);

    var bombsLeft = this.difficulty.bombs;
    var cellsLeft = length - 1;

    final cells = List<CellData>(length);

    // No bombs in the starting cell
    cells[startingCellIndex] = CellData(bomb: false);

    for (var i in cellIndexes) {
      double r = Random().nextDouble();
      double bombProbability = bombsLeft / cellsLeft;
      bool hasBomb = r <= bombProbability;
      cells[i] = CellData(bomb: hasBomb);

      cellsLeft -= 1;
      if (hasBomb) bombsLeft -= 1;
    }

    return cells
        .asMap()
        .map((cellIndex, v) => MapEntry(
            cellIndex,
            CellData(
              state: v.state,
              bomb: v.bomb,
              neighborBombs: _getNeighborIndexes(cellIndex)
                  .where((i) => cells[i].bomb)
                  .length,
            )))
        .values
        .toList();
  }

  List<int> _getNeighborIndexes(int cellIndex) {
    final int row = (cellIndex / width).floor();
    final int col = cellIndex - (row * width);

    final leftMost = 0;
    final rightMost = width - 1;
    final topMost = 0;
    final bottomMost = height - 1;

    List<int> neighborIndexes = [];

    // Top
    if (row > topMost) {
      final top = cellIndex - width;
      neighborIndexes.add(top); // top-center

      if (col > leftMost) neighborIndexes.add(top - 1); // top-left
      if (col < rightMost) neighborIndexes.add(top + 1); // top-right
    }

    if (col > leftMost) neighborIndexes.add(cellIndex - 1); // left
    if (col < rightMost) neighborIndexes.add(cellIndex + 1); // right

    // Bottom
    if (row < bottomMost) {
      final bottom = cellIndex + width;
      neighborIndexes.add(bottom); // bottom-center

      if (col > leftMost) neighborIndexes.add(bottom - 1); // bottom-left
      if (col < rightMost) neighborIndexes.add(bottom + 1); // bottom-right
    }

    return neighborIndexes;
  }
}
