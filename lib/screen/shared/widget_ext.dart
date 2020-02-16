import 'package:flutter/widgets.dart';

extension WidgetExtension on Widget {
  Widget withPadding([double all]) {
    return Padding(padding: EdgeInsets.all(all), child: this);
  }
}
