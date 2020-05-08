import 'package:flutter/foundation.dart';

class CellData with Diagnosticable {
  final bool bomb;
  final CellState state;
  final int neighborBombs;

  const CellData({
    this.state = CellState.covered,
    this.bomb = false,
    this.neighborBombs = 0,
  });

  CellData withState(CellState newState) {
    return new CellData(
      bomb: this.bomb,
      neighborBombs: this.neighborBombs,
      state: newState,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty('state', state));
    properties.add(FlagProperty('bomb', value: bomb));
  }

  @override
  String toStringShort() {
    return bomb ? "X" : "_";
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return toStringShort();
  }
}

enum CellState { covered, uncovered, marked }
