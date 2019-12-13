import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SmileyState { Chilling, Stressed, Victorious, Dead }

class SmileyFace extends StatelessWidget {
  final _painter;

  SmileyFace({Key key, SmileyState state = SmileyState.Chilling})
      : _painter = _SmileyPainter(state),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      size: Size.square(48),
    );
  }
}

class _SmileyPainter extends CustomPainter {
  final SmileyState state;
  final Paint fillPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.yellow;
  final Paint strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black87
    ..strokeWidth = 2
    ..isAntiAlias = false;
  final Paint eyePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  _SmileyPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final info = _SmileyDrawingInfo(size);
    canvas.drawCircle(info.center, info.radius, fillPaint);
    canvas.drawCircle(info.center, info.radius, strokePaint);

    switch (state) {
      case SmileyState.Chilling:
        drawChilling(canvas, info);
        break;
      case SmileyState.Stressed:
        drawStressed(canvas, info);
        break;
      case SmileyState.Victorious:
        drawVictorious(canvas, info);
        break;
      case SmileyState.Dead:
        drawDead(canvas, info);
        break;
      default:
    }
  }

  void drawChilling(Canvas canvas, _SmileyDrawingInfo info) {
    canvas.drawCircle(info.leftEye, info.eyeRadius, eyePaint);
    canvas.drawCircle(info.rightEye, info.eyeRadius, eyePaint);

    Path smile = Path()
      ..moveTo(info.mouthStart.dx, info.mouthStart.dy * .9)
      ..quadraticBezierTo(
        info.mouthCenter.dx,
        info.mouthStart.dy + info.radius / 2,
        info.mouthStart.dx + info.mouthWidth,
        info.mouthStart.dy * .9,
      );
    canvas.drawPath(smile, strokePaint);
  }

  void drawStressed(Canvas canvas, _SmileyDrawingInfo info) {
    final bigEyeRadius = info.eyeRadius * 1.3;
    canvas.drawCircle(info.leftEye, bigEyeRadius, eyePaint);
    canvas.drawCircle(info.rightEye, bigEyeRadius, eyePaint);

    final ohMouthRadius = info.mouthWidth / 3;
    var ohMouthRect = Rect.fromCenter(
      center: info.mouthCenter.translate(0, info.radius * .1),
      width: ohMouthRadius,
      height: ohMouthRadius,
    );
    canvas.drawOval(ohMouthRect, strokePaint);

    var mouthPaint = Paint()..color = Colors.black26;
    canvas.drawOval(ohMouthRect, mouthPaint);
  }

  void drawVictorious(Canvas canvas, _SmileyDrawingInfo info) {
    var leftEyeGlass = Rect.fromCenter(
      center: info.leftEye.translate(-info.eyeRadius / 2, info.eyeRadius),
      width: info.radius * 0.7,
      height: info.radius * 0.6,
    );
    var rightEyeGlass = leftEyeGlass.translate(
        info.rightEye.dx - info.leftEye.dx + info.eyeRadius, 0);
    canvas.drawOval(leftEyeGlass, eyePaint);
    canvas.drawOval(rightEyeGlass, eyePaint);

    // Glasses branches
    canvas.drawLine(
      Offset(0, info.radius),
      leftEyeGlass.centerLeft,
      strokePaint,
    );
    canvas.drawLine(
      rightEyeGlass.centerRight,
      Offset(info.radius * 2, info.radius),
      strokePaint,
    );

    // Glasses bridge
    canvas.drawLine(
      leftEyeGlass.centerRight,
      rightEyeGlass.centerLeft,
      strokePaint,
    );

    Path smile = Path()
      ..moveTo(info.mouthStart.dx + info.eyeRadius * 2, info.mouthStart.dy)
      ..quadraticBezierTo(
        info.mouthCenter.dx,
        info.mouthStart.dy + 4,
        info.mouthStart.dx + info.mouthWidth - info.eyeRadius * 2,
        info.mouthStart.dy,
      );
    canvas.drawPath(smile, strokePaint);
  }

  void drawDead(Canvas canvas, _SmileyDrawingInfo info) {
    double eyeSize = info.eyeRadius * 3;
    final leftEye =
        Rect.fromCenter(center: info.leftEye, width: eyeSize, height: eyeSize);
    canvas.drawLine(leftEye.topLeft, leftEye.bottomRight, strokePaint);
    canvas.drawLine(leftEye.topRight, leftEye.bottomLeft, strokePaint);

    final rightEye =
        Rect.fromCenter(center: info.rightEye, width: eyeSize, height: eyeSize);
    canvas.drawLine(rightEye.topLeft, rightEye.bottomRight, strokePaint);
    canvas.drawLine(rightEye.topRight, rightEye.bottomLeft, strokePaint);

    Path smile = Path()
      ..moveTo(info.mouthStart.dx, info.mouthStart.dy + info.radius / 4)
      ..quadraticBezierTo(
        info.mouthCenter.dx,
        info.mouthStart.dy - info.radius / 3,
        info.mouthStart.dx + info.mouthWidth,
        info.mouthStart.dy + info.radius / 4,
      );
    canvas.drawPath(smile, strokePaint);
  }

  @override
  bool shouldRepaint(_SmileyPainter oldDelegate) {
    return oldDelegate.state != state;
  }
}

class _SmileyDrawingInfo {
  Offset center;
  double radius;

  Offset leftEye;
  Offset rightEye;
  final double eyeRadius = 3;

  Offset mouthStart;
  double mouthWidth;

  Offset get mouthCenter => mouthStart.translate(this.mouthWidth / 2, 0);
  Offset get mouthEnd => mouthStart.translate(this.mouthWidth, 0);

  _SmileyDrawingInfo(Size size) {
    center = size.center(Offset.zero);
    radius = size.width / 2;

    final third = radius / 3;
    leftEye = center.translate(-third, -third);
    rightEye = center.translate(third, -third);

    final mouthEyeXOffset = 4;
    mouthStart =
        center.translate(-third - eyeRadius - mouthEyeXOffset, third * .8);
    mouthWidth = rightEye.dx - leftEye.dx + 2 * (eyeRadius + mouthEyeXOffset);
  }
}
