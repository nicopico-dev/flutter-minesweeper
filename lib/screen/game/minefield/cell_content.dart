import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minesweeper/domain/cell_data.dart';
import 'package:minesweeper/screen/shared/bezel_button.dart';
import 'package:minesweeper/domain/game_state.dart';

const double CELL_SIZE = 30;
const double BEZEL_SIZE = 2;
const double LABEL_SIZE = 18;

class CellContent extends StatelessWidget {
  final CellData cellData;
  final GameStatus gameStatus;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  CellContent({
    Key key,
    @required this.cellData,
    this.gameStatus = GameStatus.Play,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: this.onLongPress,
      child: Builder(builder: (context) {
        switch (cellData.state) {
          case CellState.covered:
            return BezelButton(onPressed: this.onTap);
            break;

          case CellState.uncovered:
            if (cellData.bomb) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
                  if (gameStatus == GameStatus.Lose)
                    Container(color: Colors.red),
                  Container(
                    child: Image.asset("assets/images/bomb.png"),
                    padding: EdgeInsets.all(4),
                  )
                ],
              );
            } else {
              int neighborBombs = cellData.neighborBombs;
              if (neighborBombs > 0) {
                return NeighborCount(neighborBombs: neighborBombs);
              }
            }
            break;

          case CellState.marked:
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                BezelButton(onPressed: null),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset("assets/images/flag.png"),
                ),
                if (!cellData.bomb && gameStatus == GameStatus.Lose) Wrong(),
              ],
            );
            break;
        }

        return Container();
      }),
    );
  }
}

class NeighborCount extends StatelessWidget {
  static const BOMBS_TEXT_COLORS = <Color>[
    Colors.blue,
    Colors.green,
    Colors.red
  ];
  final int neighborBombs;

  NeighborCount({Key key, @required this.neighborBombs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bombTextColorIndex = min(neighborBombs, BOMBS_TEXT_COLORS.length) - 1;
    return Center(
      child: Text(
        this.neighborBombs.toString(),
        style: TextStyle(
          color: BOMBS_TEXT_COLORS[bombTextColorIndex],
          fontSize: LABEL_SIZE,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Wrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CustomPaint(painter: _WrongPainter()),
    );
  }
}

class _WrongPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final origin = Offset.zero;
    canvas.drawLine(origin, size.bottomRight(origin), paint);
    canvas.drawLine(size.bottomLeft(origin), size.topRight(origin), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
