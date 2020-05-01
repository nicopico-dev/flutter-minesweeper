class CellData {
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
}

enum CellState { covered, uncovered, marked }
