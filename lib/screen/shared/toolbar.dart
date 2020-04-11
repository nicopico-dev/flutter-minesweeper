import 'package:flutter/material.dart';
import 'package:minesweeper/screen/shared/bezel.dart';
import 'package:minesweeper/screen/shared/bezel_button.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Toolbar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF0208A2),
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
    return Container(
      width: 38,
      height: 38,
      color: BEZEL_DEFAULT_COLOR,
      child: Icon(Icons.menu),
    );
  }
}
