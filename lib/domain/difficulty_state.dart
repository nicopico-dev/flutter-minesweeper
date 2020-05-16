import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/domain/skill.dart';

class DifficultyState extends ChangeNotifier with DiagnosticableTreeMixin {
  Skill _skill = Skill.Beginner;
  Difficulty _customDifficulty = Skill.Beginner.difficulty;

  Skill get skill => _skill;
  Difficulty get difficulty =>
      _skill == Skill.Custom ? _customDifficulty : _skill.difficulty;

  set skill(Skill value) {
    _skill = value;
    notifyListeners();
  }

  set customDifficulty(Difficulty value) {
    _customDifficulty = value;
    if (_skill == Skill.Custom) notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty('Skill', _skill));
    properties.add(DiagnosticsProperty('Custom difficulty', _customDifficulty));
  }
}
