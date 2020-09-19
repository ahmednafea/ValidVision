import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/actions/open_home_screen_action.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/identity/actions/open_login_screen_action.dart';
import 'package:validvision/modules/identity/actions/open_signup_screen_action.dart';
import 'package:validvision/modules/identity/actions/open_welcome_screen_action.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../../routes.dart';
import 'navigation_key.dart';

_route(String route, {bool isReplacement = false}) {
  Map<String, WidgetBuilder> r = routes();

  if (isReplacement == true) {
    navigatorKey.currentState
        .pushReplacement(MaterialPageRoute(builder: r[route]));
  } else {
    navigatorKey.currentState.push(MaterialPageRoute(builder: r[route]));
  }
}

navigationMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);
  switch (action.runtimeType) {
    case OpenHomeScreenAction:
      _route("home_screen");
      break;
    case OpenWelcomeScreenAction:
      Shared.isFirstTime ? _route("opener_screen") : _route("welcome_screen");
      break;
    case OpenSignUpScreenAction:
      _route("signup_screen");
      break;
    case OpenLoginScreenAction:
      _route("login_screen");
  }
}
