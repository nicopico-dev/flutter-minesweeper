import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  final bool readOnly;

  const NumericFormField({
    Key key,
    this.labelText,
    this.hintText,
    this.icon,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: icon,
      ),
      readOnly: readOnly,
    );
  }
}
