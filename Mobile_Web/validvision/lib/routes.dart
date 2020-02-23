import 'package:flutter/material.dart';

import 'modules/core/screens/home_screen.dart';

Map<String, WidgetBuilder> _routes;

Map<String, WidgetBuilder> routes() {
  if (_routes == null) {
    _routes = {"home_screen": (context) => HomeScreen()};
  }
  return _routes;
}
