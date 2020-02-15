import 'package:flutter/material.dart';

class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
      color: Colors.black,
    );
    var textStyleUnderline =
        textStyle.copyWith(decoration: TextDecoration.underline);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      padding: EdgeInsets.all(4),
      child: Row(children: <Widget>[
        SizedBox(width: 8),
        RichText(
          text: TextSpan(
            text: 'G',
            style: textStyleUnderline,
            children: [TextSpan(text: "ame", style: textStyle)],
          ),
        ),
        SizedBox(width: 16),
        RichText(
          text: TextSpan(
            text: 'H',
            style: textStyleUnderline,
            children: [TextSpan(text: "elp", style: textStyle)],
          ),
        ),
      ]),
    );
  }
}
