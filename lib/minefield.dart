import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cell_data.dart';
import 'cell_painter.dart';
import 'game_state.dart';

class Minefield extends StatelessWidget {
  final int width;
  final int height;

  const Minefield({@required this.width, @required this.height});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      final rows = <TableRow>[];
      for (int row = 0; row < height; row++) {
        final cells = <Widget>[];
        for (int col = 0; col < width; col++) {
          int cellIndex = row * 10 + col;
          final cellData = game.cellsData[cellIndex];
          cells.add(
            TableCell(
              child: MineCell(cellIndex, cellData),
            ),
          );
        }
        rows.add(TableRow(children: cells));
      }
      return Table(
        border: TableBorder.all(color: Color(0xFFADADAD)),
        defaultColumnWidth: FixedColumnWidth(CELL_SIZE),
        children: rows,
      );
    });
  }
}

class MineCell extends StatefulWidget {
  final int cellIndex;
  final CellData cellData;

  const MineCell(this.cellIndex, this.cellData);

  @override
  _MineCellState createState() => _MineCellState();
}

class _MineCellState extends State<MineCell> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final cellData = widget.cellData;
    var cell = CustomPaint(
      size: Size.square(CELL_SIZE),
      painter: CellPainter(cellData, pressed),
    );

    GameState game = Provider.of<GameState>(context, listen: false);
    bool isCovered = cellData.state == CellState.covered;
    bool isMarked = cellData.state == CellState.marked;

    bool canPlay = (isCovered || isMarked) && game.status == GameStatus.Play;

    if (canPlay) {
      return GestureDetector(
        onTapDown: this._onPressed,
        onTapUp: this._onPressed,
        onTapCancel: this._onPressed,
        onTap: isMarked ? null : () => game.uncover(widget.cellIndex),
        onLongPress: () => game.toggleMark(widget.cellIndex),
        child: cell,
      );
    } else {
      return cell;
    }
  }

  void _onPressed([details]) {
    setState(() {
      this.pressed = details is TapDownDetails;
    });
  }
}
