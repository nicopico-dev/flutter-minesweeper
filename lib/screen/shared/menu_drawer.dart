import 'package:flutter/material.dart';
import 'package:minesweeper/domain/game_state.dart';
import 'package:minesweeper/domain/skill.dart';
import 'package:minesweeper/screen/shared/constants.dart';
import 'package:provider/provider.dart';

typedef void _OnSkillChanged(Skill value);

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<GameState>(
        builder: (context, game, child) {
          _OnSkillChanged onSkillChanged = (value) {
            game.skill = value;
            // Close drawer
            Navigator.of(context).pop();
          };

          return ListView(
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
                groupValue: game.skill,
                onChanged: onSkillChanged,
              ),
              RadioListTile<Skill>(
                title: Text("Intermediate"),
                value: Skill.Intermediate,
                groupValue: game.skill,
                onChanged: onSkillChanged,
              ),
              RadioListTile<Skill>(
                title: Text("Expert"),
                value: Skill.Expert,
                groupValue: game.skill,
                onChanged: onSkillChanged,
              ),
              // TODO Add "custom" difficulty level
            ],
          );
        },
      ),
    );
  }
}
