import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:minesweeper/domain/smiley_state.dart';

import 'cell_data.dart';
import 'skill.dart';

enum GameStatus { Play, Win, Lose }

class GameState extends ChangeNotifier {
  final int width;
  final int height;
  final double bombPercent;

  final _GameInitializer _initializer;
  final _CellHelper _cellHelper;

  Skill _skill = Skill.Beginner;
  Skill get skill => _skill;
  set skill(Skill value) {
    _skill = value;
    _difficulty = value.difficulty;
    notifyListeners();
  }

  Difficulty _difficulty;
  Difficulty get difficulty => _difficulty ?? _skill.difficulty;
  set difficulty(Difficulty value) {
    _skill = Skill.Custom;
    _difficulty = value;
    notifyListeners();
  }

  List<CellData> _cellsData = [];
  UnmodifiableListView<CellData> get cellsData =>
      UnmodifiableListView(_cellsData);

  GameStatus _status = GameStatus.Play;
  GameStatus get status => _status;

  SmileyState _smiley = SmileyState.Chilling;
  SmileyState get smiley => _smiley;

  int _gameStart;
  int get gameStart => _gameStart;

  GameState({
    @required this.width,
    @required this.height,
    this.bombPercent = 0.15,
  })  : _initializer = _GameInitializer(width, height, bombPercent),
        _cellHelper = _CellHelper(width, height) {
    _init();
  }

  void _init() {
    _cellsData = _initializer._initializeCellsData();
    _status = GameStatus.Play;
    _smiley = SmileyState.Chilling;
    _gameStart = null;
  }

  int get unmarkedBombs {
    int bombs = 0;
    int marks = 0;
    for (final cell in _cellsData) {
      bombs += cell.bomb ? 1 : 0;
      marks += cell.state == CellState.marked ? 1 : 0;
    }
    return bombs - marks;
  }

  void restart() {
    _init();
    notifyListeners();
  }

  void uncover(int cellIndex) {
    if (_gameStart == null) {
      _gameStart = DateTime.now().millisecondsSinceEpoch;
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

  bool _checkVictory() =>
      _cellsData.every((c) => c.state == CellState.uncovered || c.bomb);

  void _uncoverNeighbors(int cellIndex) {
    for (int i in _cellHelper.getNeighborIndexes(cellIndex)) {
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

class _GameInitializer {
  final int width;
  final int height;
  final double bombPercent;

  final _CellHelper _cellHelper;

  _GameInitializer([this.width, this.height, this.bombPercent])
      : _cellHelper = _CellHelper(width, height);

  List<CellData> _initializeCellsData() {
    List<CellData> cells = _plantBombs(width * height, bombPercent);
    return cells
        .asMap()
        .map((cellIndex, v) => MapEntry(
            cellIndex,
            CellData(
              state: v.state,
              bomb: v.bomb,
              neighborBombs: _countNeighborBombs(cellIndex, cells),
            )))
        .values
        .toList();
  }

  static List<CellData> _plantBombs(int length, double bombPercent) {
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

  int _countNeighborBombs(int cellIndex, List<CellData> cellsData) =>
      _cellHelper
          .getNeighborIndexes(cellIndex)
          .where((i) => cellsData[i].bomb)
          .length;
}

class _CellHelper {
  final int width;
  final int height;

  const _CellHelper([this.width, this.height]);

  List<int> getNeighborIndexes(int cellIndex) {
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
