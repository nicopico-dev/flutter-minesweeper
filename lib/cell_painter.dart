import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'cell_data.dart';

const double CELL_SIZE = 30;
const double BEZEL_SIZE = 2;
const double LABEL_SIZE = 18;

class CellPainter extends CustomPainter {
  final CellData cellData;
  final int neighborBombs;
  final bool pressed;

  final Color bgPaint = const Color(0xFFBDBDBD);

  const CellPainter(this.cellData, this.neighborBombs, this.pressed);

  @override
  void paint(Canvas canvas, Size size) {
    switch (cellData.state) {
      case CellState.covered:
        if (pressed) {
          _drawUncovered(canvas, size);
        } else {
          _drawCovered(canvas, size);
        }
        break;

      case CellState.uncovered:
        _drawUncovered(canvas, size);
        if (cellData.bomb) {
          _drawBomb(canvas, size);
        } else if (neighborBombs > 0) {
          _drawNeighborBombs(canvas, size);
        }
        break;

      case CellState.flagged:
        _drawCovered(canvas, size);
        _drawFlag(canvas, size);
        break;
    }
  }

  @override
  bool shouldRepaint(CellPainter oldDelegate) {
    return oldDelegate.cellData != cellData || oldDelegate.pressed != pressed;
  }

  void _drawCovered(Canvas canvas, Size size) {
    // Background
    var paint = Paint()
      ..color = const Color(0xFFBDBBBE)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Top-left
    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = BEZEL_SIZE;

    var path = Path();
    path.moveTo(size.width, 0);
    path.relativeLineTo(-BEZEL_SIZE, BEZEL_SIZE);
    path.relativeLineTo(-size.width + 2 * BEZEL_SIZE, 0);
    path.relativeLineTo(0, size.height - 2 * BEZEL_SIZE);
    canvas.drawPath(path, paint);

    // Bottom-right
    paint = Paint()
      ..color = const Color(0xFF7D797C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = BEZEL_SIZE;

    path.reset();
    path.moveTo(size.width, 0);
    path.relativeLineTo(-BEZEL_SIZE, BEZEL_SIZE);
    path.relativeLineTo(0, size.height - 2 * BEZEL_SIZE);
    path.relativeLineTo(-size.width + 2 * BEZEL_SIZE, 0);
    canvas.drawPath(path, paint);
  }

  void _drawUncovered(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawFlag(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    var path = Path();
    path.moveTo(size.width / 2, 4);
    path.relativeLineTo(0, size.height - 8);
    canvas.drawPath(path, paint);
  }

  void _drawBomb(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3,
      paint,
    );
  }

  static const BOMBS_TEXT_COLORS = <Color>[
    Colors.blue,
    Colors.green,
    Colors.red
  ];

  void _drawNeighborBombs(Canvas canvas, Size size) {
    final bombTextColorIndex =
        min(this.neighborBombs, BOMBS_TEXT_COLORS.length) - 1;
    final textPainter = (String text) => TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: BOMBS_TEXT_COLORS[bombTextColorIndex],
              fontSize: LABEL_SIZE,
              fontWeight: FontWeight.w700,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
    textPainter(this.neighborBombs.toString())
      ..layout(minWidth: size.width, maxWidth: size.width)
      ..paint(
        canvas,
        Offset(0, LABEL_SIZE / 4),
      );
  }
}
