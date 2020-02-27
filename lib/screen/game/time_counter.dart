import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/screen/shared/digital_counter.dart';
import 'package:provider/provider.dart';

class TimeCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, game, child) {
      return _TimeCounter(game.gameStart, game.status == GameStatus.Play);
    });
  }
}

class _TimeCounter extends StatefulWidget {
  final int gameStart;
  final bool playing;

  _TimeCounter(this.gameStart, this.playing);

  @override
  _TimeCounterState createState() => _TimeCounterState();
}

class _TimeCounterState extends State<_TimeCounter> {
  int seconds;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _startTimerWhenReady();
  }

  @override
  Widget build(BuildContext context) {
    return DigitalCounter(value: seconds);
  }

  @override
  void didUpdateWidget(_TimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gameStart != widget.gameStart ||
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
    if (widget.playing && widget.gameStart != null) {
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
