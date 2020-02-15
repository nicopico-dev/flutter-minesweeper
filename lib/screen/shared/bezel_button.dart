import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bezel.dart';

class BezelButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool depressable;

  const BezelButton({
    Key key,
    this.child,
    @required this.onPressed,
    this.depressable = false,
  });

  @override
  _BezelButtonState createState() => _BezelButtonState();
}

class _BezelButtonState extends State<BezelButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (e) => updateState(pressed: true),
      onTapUp: (e) => updateState(pressed: false),
      onTapCancel: () => updateState(pressed: false),
      onTap: this.widget.onPressed,
      child: Builder(builder: (context) {
        if (!pressed)
          return Bezel(child: widget.child);
        else if (widget.depressable)
          return Bezel(
              child: widget.child,
              bezelLightPosition: BezelLightPosition.SouthEast);
        else
          return Container(
            color: BEZEL_DEFAULT_COLOR,
            padding: EdgeInsets.all(BEZEL_DEFAULT_SIZE),
            child: widget.child,
          );
      }),
    );
  }

  void updateState({bool pressed}) {
    setState(() {
      this.pressed = pressed;
    });
  }
}
