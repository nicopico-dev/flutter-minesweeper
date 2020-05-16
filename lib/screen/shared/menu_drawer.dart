import 'package:flutter/material.dart';
import 'package:minesweeper/domain/difficulty_state.dart';
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
    var state = Provider.of<DifficultyState>(context, listen: false);
    skill = state.skill;
    difficulty = state.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    // Workaround for Flutter bug "Textfield in Drawer does not move above keyboard when in focus"
    // https://github.com/flutter/flutter/issues/38825
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom ?? 0;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
          Align(
            child: RaisedButton(
              child: Text("Start game!"),
              onPressed: onStartGame,
            ),
          ),
          SizedBox(height: 8),
          // Add a space with the same height as the keyboard to workaround bug 38825
          // (see above)
          SizedBox(height: keyboardHeight)
        ],
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
    var state = Provider.of<DifficultyState>(context, listen: false);
    state.skill = skill;
    if (skill == Skill.Custom) {
      var formState = _formKey.currentState;
      if (formState.validate()) {
        formState.save();
        state.customDifficulty = _difficultyReader.value;
      }
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }
}
