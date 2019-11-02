import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CellData {
  final bool bomb;
  final CellState state;

  CellData({@required this.bomb, this.state = CellState.covered});
}

enum CellState { covered, uncovered, marked }

class MineCell extends StatelessWidget {
  final CellData cellData;

  MineCell(this.cellData);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
