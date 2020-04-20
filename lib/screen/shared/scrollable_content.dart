import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minesweeper/screen/shared/scrollbar.dart';

class ScrollableContent extends StatelessWidget {
  final Widget child;

  const ScrollableContent({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyScrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: MyScrollbar(
            child: SingleChildScrollView(
              child: this.child,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}
