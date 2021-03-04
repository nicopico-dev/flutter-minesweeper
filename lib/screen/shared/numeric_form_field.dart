import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  final bool enabled;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<int> onSaved;

  const NumericFormField({
    Key key,
    this.labelText,
    this.hintText,
    this.icon,
    this.enabled = true,
    this.controller,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        icon: icon,
      ),
      enabled: enabled,
      readOnly: !enabled,
      validator: validator,
      onSaved: (value) => onSaved(int.parse(value)),
    );
  }
}
