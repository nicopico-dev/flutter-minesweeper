import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'color_transform.dart';

const Color BEZEL_DEFAULT_COLOR = const Color(0xFFBDBBBE);
const double BEZEL_DEFAULT_SIZE = 3;

enum BezelLightPosition { NorthWest, SouthEast }

class Bezel extends StatelessWidget {
  final double bezelSize;
  final _BezelPainter _painter;
  final Widget child;

  Bezel({
    Key key,
    this.bezelSize = BEZEL_DEFAULT_SIZE,
    Color bezelBaseColor = BEZEL_DEFAULT_COLOR,
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

    Color lightColor = baseColor.lighten(0.3);
    Color darkColor = baseColor.darken(0.3);
    Color topColor =
        lightPosition == BezelLightPosition.NorthWest ? lightColor : darkColor;
    Color bottomColor =
        lightPosition == BezelLightPosition.NorthWest ? darkColor : lightColor;

    // Top-left
    paint = Paint()
      ..color = topColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = bezelSize;

    final halfBezelSize = bezelSize / 2;

    var path = Path();
    path.moveTo(size.width, halfBezelSize);
    path.relativeLineTo(-size.width + halfBezelSize, 0);
    path.relativeLineTo(0, size.height - halfBezelSize);
    canvas.drawPath(path, paint);

    // Bottom-right
    paint = Paint()
      ..color = bottomColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = bezelSize;

    path.reset();
    path.moveTo(size.width - halfBezelSize, bezelSize);
    path.relativeLineTo(0, size.height - 1.5 * bezelSize);
    path.relativeLineTo(-size.width + 1.5 * bezelSize, 0);
    canvas.drawPath(path, paint);

    // Corners
    paint = Paint()
      ..color = bottomColor
      ..style = PaintingStyle.fill;

    // Bottom-right corner
    path.reset();
    path.moveTo(0, size.height);
    path.relativeLineTo(bezelSize, 0);
    path.relativeLineTo(0, -bezelSize);
    path.close();
    canvas.drawPath(path, paint);

    // Top-left corner
    path.reset();
    path.moveTo(size.width - bezelSize, bezelSize);
    path.relativeLineTo(bezelSize, 0);
    path.relativeLineTo(0, -bezelSize);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BezelPainter oldDelegate) {
    return oldDelegate.bezelSize != bezelSize ||
        oldDelegate.lightPosition != lightPosition ||
        oldDelegate.baseColor != baseColor;
  }
}
