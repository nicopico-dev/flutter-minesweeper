import 'package:flutter/material.dart';
import 'package:minesweeper/cell.dart';

const double CELL_SIZE = 30;
const double BEZEL_SIZE = 2;

class Minefield extends StatelessWidget {
  final int width;
  final int height;
  final List<CellData> cellsData;

  Minefield({
    @required this.width,
    @required this.height,
    @required this.cellsData,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    for (int row = 0; row < height; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < width; col++) {
        int cellIndex = row * 10 + col;
        cells.add(
          TableCell(child: MineCell(cellsData[cellIndex])),
        );
      }
      rows.add(TableRow(children: cells));
    }
    return Table(
      border: TableBorder.all(color: Color(0xFFADADAD)),
      defaultColumnWidth: FixedColumnWidth(CELL_SIZE),
      children: rows,
    );
  }
}

class MineCell extends StatelessWidget {
  final CellData cellData;

  MineCell(this.cellData);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(CELL_SIZE),
      painter: _CellPainter(cellData),
    );
  }
}

class _CellPainter extends CustomPainter {
  CellData cellData;

  final Color bgPaint = const Color(0xFFBDBDBD);

  _CellPainter(this.cellData);

  @override
  void paint(Canvas canvas, Size size) {
    drawUncovered(canvas, size);
  }

  @override
  bool shouldRepaint(_CellPainter oldDelegate) {
    return oldDelegate.cellData != cellData;
  }

  void drawUncovered(Canvas canvas, Size size) {
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
      ..color = Color(0xFF7D797C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = BEZEL_SIZE;

    path.reset();
    path.moveTo(size.width, 0);
    path.relativeLineTo(-BEZEL_SIZE, BEZEL_SIZE);
    path.relativeLineTo(0, size.height - 2 * BEZEL_SIZE);
    path.relativeLineTo(-size.width + 2 * BEZEL_SIZE, 0);
    canvas.drawPath(path, paint);
  }
}
