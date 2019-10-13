// flutter package imports
import 'package:flutter/material.dart';

class GelMenuItem {
  final String title;
  final IconData iconData;
  final bool showBeforeDivider;

  GelMenuItem(
      {@required this.title,
      @required this.iconData,
      this.showBeforeDivider = true});
}
