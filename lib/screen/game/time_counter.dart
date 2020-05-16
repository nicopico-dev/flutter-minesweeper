import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/screen/shared/digital_counter.dart';

class TimeCounter extends StatefulWidget {
  final int start;
  final bool playing;

  TimeCounter({@required this.start, @required this.playing});

  @override
  _TimeCounterState createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  int seconds;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _startTimerWhenReady();
  }

  @override
  Widget build(BuildContext context) {
    // Make sure the value is no bigger than 999
    return DigitalCounter(value: min(seconds, 999));
  }

  @override
  void didUpdateWidget(TimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start ||
        oldWidget.playing != widget.playing) {
      // Stop the timer
      timer?.cancel();
      if (widget.playing) {
        _startTimerWhenReady();
      }
    }
  }

  void _startTimerWhenReady() {
    seconds = 0;
    if (widget.playing && widget.start != null) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => {
          setState(() {
            seconds += 1;
          })
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
