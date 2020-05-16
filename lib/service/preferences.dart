import 'package:minesweeper/domain/skill.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _SKILL_KEY = "skill";
const _CUSTOM_WIDTH_KEY = "custom_width";
const _CUSTOM_HEIGHT_KEY = "custom_height";
const _CUSTOM_BOMBS_KEY = "custom_bombs";

class Preferences {
  Future<SharedPreferences> _prefs;

  Preferences() {
    _prefs = SharedPreferences.getInstance();
  }

  Future<Skill> getSkill() async {
    var prefs = await _prefs;
    if (prefs.containsKey(_SKILL_KEY)) {
      var skillValue = (await _prefs).getString(_SKILL_KEY);
      return Skill.values.singleWhere((skill) => skill.toString() == skillValue,
          orElse: () => Skill.Beginner);
    } else {
      return Skill.Beginner;
    }
  }

  void setSkill(Skill value) async {
    var prefs = await _prefs;
    prefs.setString(_SKILL_KEY, value.toString());
  }

  Future<Difficulty> getCustomDifficulty() async {
    var prefs = await _prefs;
    if (prefs.containsKey(_CUSTOM_WIDTH_KEY) &&
        prefs.containsKey(_CUSTOM_HEIGHT_KEY) &&
        prefs.containsKey(_CUSTOM_BOMBS_KEY)) {
      return Difficulty(
        prefs.getInt(_CUSTOM_WIDTH_KEY),
        prefs.getInt(_CUSTOM_HEIGHT_KEY),
        prefs.getInt(_CUSTOM_BOMBS_KEY),
      );
    } else {
      return null;
    }
  }

  void setCustomDifficulty(Difficulty value) async {
    var prefs = await _prefs;
    prefs.setInt(_CUSTOM_WIDTH_KEY, value.width);
    prefs.setInt(_CUSTOM_HEIGHT_KEY, value.height);
    prefs.setInt(_CUSTOM_BOMBS_KEY, value.bombs);
  }
}
