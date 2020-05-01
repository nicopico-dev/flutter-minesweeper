import 'package:flutter/material.dart';
import 'package:minesweeper/screen/shared/bezel_button.dart';

import 'constants.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Toolbar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.WIN_BLUE,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MenuButton(),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          BezelButton(child: Icon(Icons.arrow_drop_down), onPressed: null)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(38);
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Scaffold.of(context, nullOk: true)?.openDrawer(),
      child: Container(
        width: 38,
        height: 38,
        color: Constants.BEZEL_DEFAULT_COLOR,
        child: Icon(Icons.menu),
      ),
    );
  }
}
