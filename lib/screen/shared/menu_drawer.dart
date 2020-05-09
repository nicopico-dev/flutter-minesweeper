import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/screen/shared/constants.dart';
import 'package:provider/provider.dart';

import 'custom_difficulty_form.dart';

typedef void OnSkillChanged(Skill value);

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final _formKey = GlobalKey<FormState>();
  final _difficultyReader = DifficultyReader();

  Skill skill;
  Difficulty difficulty;

  @override
  void initState() {
    super.initState();
    GameState game = Provider.of<GameState>(context, listen: false);
    skill = game.skill;
    difficulty = game.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                child: Text(
                  "Minesweeper",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(color: Constants.WIN_BLUE),
            ),
            RadioListTile<Skill>(
              title: Text("Beginner"),
              value: Skill.Beginner,
              groupValue: skill,
              onChanged: onSkillChanged,
            ),
            RadioListTile<Skill>(
              title: Text("Intermediate"),
              value: Skill.Intermediate,
              groupValue: skill,
              onChanged: onSkillChanged,
            ),
            RadioListTile<Skill>(
              title: Text("Expert"),
              value: Skill.Expert,
              groupValue: skill,
              onChanged: onSkillChanged,
            ),
            RadioListTile<Skill>(
              title: Text("Custom"),
              value: Skill.Custom,
              groupValue: skill,
              onChanged: onSkillChanged,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 8, right: 16, bottom: 16),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: CustomDifficultyForm(
                formKey: _formKey,
                difficulty: difficulty,
                enabled: skill == Skill.Custom,
                reader: _difficultyReader,
              ),
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text("Start game!"),
              onPressed: onStartGame,
            )
          ],
        ),
      ),
    );
  }

  void onSkillChanged(Skill skill) {
    setState(() {
      this.skill = skill;
      this.difficulty = skill?.difficulty ?? this.difficulty;
    });
  }

  void onStartGame() {
    var game = Provider.of<GameState>(context, listen: false);
    if (skill == Skill.Custom) {
      var formState = _formKey.currentState;
      if (formState.validate()) {
        formState.save();
        game.setSkill(skill, _difficultyReader.value);
        Navigator.of(context).pop();
      }
    } else {
      game.setSkill(skill);
      Navigator.of(context).pop();
    }
  }
}
