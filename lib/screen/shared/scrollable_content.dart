import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollableContent extends StatelessWidget {
  final Widget child;

  final _horz = ScrollController();
  final _vert = ScrollController();

  ScrollableContent({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
        controller: _horz,
        child: Scrollbar(
          controller: _vert,
          child: SingleChildScrollView(
            controller: _horz,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              controller: _vert,
              scrollDirection: Axis.vertical,
              child: this.child,
            ),
          ),
        ),
      ),
    );
  }
}
