import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/service/preferences.dart';

class DifficultyState extends ChangeNotifier with DiagnosticableTreeMixin {
  Preferences preferences;

  Skill _skill = Skill.Beginner;
  Difficulty _customDifficulty = Skill.Beginner.difficulty;

  DifficultyState({
    @required this.preferences,
    Skill skill = Skill.Beginner,
    Difficulty customDifficulty,
  })  : _skill = skill,
        _customDifficulty = customDifficulty ?? skill.difficulty {
    init();
  }

  init() async {
    _skill = await preferences.getSkill() ?? _skill;
    _customDifficulty =
        await preferences.getCustomDifficulty() ?? _customDifficulty;
    notifyListeners();
  }

  Skill get skill => _skill;
  Difficulty get difficulty {
    if (_skill == Skill.Custom)
      return _customDifficulty;
    else
      return _skill.difficulty;
  }

  set skill(Skill value) {
    _skill = value;
    notifyListeners();
    preferences.setSkill(value);
  }

  set customDifficulty(Difficulty value) {
    _customDifficulty = value;
    if (_skill == Skill.Custom) notifyListeners();
    preferences.setCustomDifficulty(value);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty('Skill', _skill));
    properties.add(DiagnosticsProperty('Custom difficulty', _customDifficulty));
  }
}
