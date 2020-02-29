import 'package:flutter/material.dart';
import 'package:validvision/modules/identity/screens/login_screen.dart';
import 'package:validvision/modules/identity/screens/signup_screen.dart';
import 'package:validvision/modules/identity/screens/welcome_screen.dart';

import 'modules/core/screens/home_screen.dart';
import 'modules/core/screens/opener_screen.dart';

Map<String, WidgetBuilder> _routes;

Map<String, WidgetBuilder> routes() {
  if (_routes == null) {
    _routes = {
      "home_screen": (context) => HomeScreen(),
      "opener_screen": (context) => OpenerScreen(),
      "welcome_screen": (context) => WelcomeScreen(),
      "login_screen": (context) => LoginScreen(),
      "signup_screen": (context) => SignUpScreen()
    };
  }
  return _routes;
}
