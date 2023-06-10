import 'package:flutter/material.dart';

class System {
  static Object? inDarkMode(BuildContext context, Object? Function() callback) {
    if (MediaQuery.of(context).platformBrightness != Brightness.dark) {
      return null;
    }
    return callback();
  }
}
