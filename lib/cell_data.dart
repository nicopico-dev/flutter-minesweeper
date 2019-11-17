import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CellData {
  final bool bomb;
  final CellState state;
  final int neighborBombs;

  const CellData({
    @required this.bomb,
    this.state = CellState.covered,
    this.neighborBombs,
  });

  CellData withState(CellState newState) {
    return new CellData(
      bomb: this.bomb,
      neighborBombs: this.neighborBombs,
      state: newState,
    );
  }
}

enum CellState { covered, uncovered, marked }
