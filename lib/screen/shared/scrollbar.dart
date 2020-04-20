// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kScrollbarThickness = 6.0;

class MyScrollbar extends StatefulWidget {
  const MyScrollbar({Key key, @required this.child, this.controller})
      : super(key: key);

  final Widget child;

  final ScrollController controller;

  @override
  _MyScrollbarState createState() => _MyScrollbarState();
}

class _MyScrollbarState extends State<MyScrollbar>
    with TickerProviderStateMixin {
  ScrollbarPainter _materialPainter;
  TextDirection _textDirection;
  Color _themeColor;
  Animation<double> _fadeoutOpacityAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _materialPainter = _buildMaterialScrollbarPainter();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _materialPainter,
      child: RepaintBoundary(
        child: widget.child,
      ),
    );
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: _themeColor,
      textDirection: _textDirection,
      thickness: _kScrollbarThickness,
      fadeoutOpacityAnimation: _fadeoutOpacityAnimation,
      padding: MediaQuery.of(context).padding,
    );
  }
}
