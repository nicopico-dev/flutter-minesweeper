import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum BezelLightPosition { NorthWest, SouthEast }

class Bezel extends StatelessWidget {
  final double bezelSize;
  final _BezelPainter _painter;
  final Widget child;

  Bezel({
    Key key,
    this.bezelSize = 2,
    Color bezelBaseColor = const Color(0xFFBDBBBE),
    BezelLightPosition bezelLightPosition = BezelLightPosition.NorthWest,
    this.child,
  })  : _painter = _BezelPainter(bezelSize, bezelBaseColor, bezelLightPosition),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: this._painter,
      child: Padding(
        padding: EdgeInsets.all(this.bezelSize),
        child: this.child,
      ),
    );
  }
}

class _BezelPainter extends CustomPainter {
  final BezelLightPosition lightPosition;
  final double bezelSize;
  final Color baseColor;

  const _BezelPainter(this.bezelSize, this.baseColor, this.lightPosition);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    var paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Top-left
    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = bezelSize;

    var path = Path();
    path.moveTo(size.width, 0);
    path.relativeLineTo(-bezelSize, bezelSize);
    path.relativeLineTo(-size.width + 2 * bezelSize, 0);
    path.relativeLineTo(0, size.height - 2 * bezelSize);
    canvas.drawPath(path, paint);

    // Bottom-right
    paint = Paint()
      ..color = const Color(0xFF7D797C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = bezelSize;

    path.reset();
    path.moveTo(size.width, 0);
    path.relativeLineTo(-bezelSize, bezelSize);
    path.relativeLineTo(0, size.height - 2 * bezelSize);
    path.relativeLineTo(-size.width + 2 * bezelSize, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BezelPainter oldDelegate) {
    return false;
  }
}
