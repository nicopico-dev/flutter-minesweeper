import 'package:flutter/material.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/preferences.dart';
import 'package:minesweeper/screen/game/game_screen.dart';
import 'package:provider/provider.dart';

import 'domain/game_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _prefs = Preferences();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper Demo',
      home: FutureProvider(
        create: _createState,
        initialData: GameState(),
        child: GameScreen(),
        lazy: false,
      ),
    );
  }

  Future<GameState> _createState(BuildContext context) async {
    var skill = await _prefs.getSkill();
    var difficulty = await _prefs.getDifficulty();
    var game = GameState(
      initialSkill: skill,
      customDifficulty: difficulty,
      onSkillChanged: _savePreferences,
    );

    return game;
  }

  void _savePreferences(Skill skill, Difficulty difficulty) {
    _prefs.setSkill(skill);
    _prefs.setDifficulty(difficulty);
  }
}
