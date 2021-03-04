import 'package:flutter/material.dart';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

final ThemeData theme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    backgroundColor: Colors.white,
  ),
).copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
);
