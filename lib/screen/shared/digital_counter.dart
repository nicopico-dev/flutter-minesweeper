import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/screen/shared/bezel.dart';

class DigitalCounter extends StatelessWidget with DiagnosticableTreeMixin {
  final int value;

  const DigitalCounter({Key key, this.value})
      : assert(value == null || value >= 0 && value < 1000),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseStyle = const TextStyle(
      fontSize: 54,
      fontFamily: 'Digital7',
      color: Color(0xFF420616),
    );
    final valueStyle = baseStyle.copyWith(color: Color(0xFFB72317));

    EdgeInsets counterPadding;
    if (Platform.isAndroid) {
      counterPadding = EdgeInsets.all(4);
    } else {
      counterPadding = EdgeInsets.zero;
    }

    return Bezel(
      bezelLightPosition: BezelLightPosition.SouthEast,
      bezelSize: 2,
      child: Container(
        padding: counterPadding,
        color: Color(0xFF1A0200),
        child: Stack(children: [
          Text(
            "888",
            style: baseStyle,
          ),
          if (value != null)
            Text(
              value.toString().padLeft(3, '0'),
              style: valueStyle,
            )
        ]),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('value', this.value));
  }
}
