import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/actions/open_home_screen_action.dart';
import 'package:validvision/modules/core/models/app_state.dart';

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
      _route("home_screen", isReplacement: true);
      break;
  }
}
