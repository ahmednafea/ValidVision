import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validvision/routes.dart';

import 'modules/core/middleware/home_middleware.dart';
import 'modules/core/middleware/navigation_key.dart';
import 'modules/core/middleware/navigation_middleware.dart';
import 'modules/core/models/app_state.dart';
import 'modules/core/reducers/home_reducer.dart';
import 'modules/core/screens/splash_screen.dart';
import 'modules/shared/shared.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ValidVisionApp());
}

loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  print('${DateTime.now()} $action ');
  next(action);
}

AppState init() => AppState();

class ValidVisionApp extends StatefulWidget {
  @override
  ValidVisionAppState createState() => ValidVisionAppState();
}

class ValidVisionAppState extends State<ValidVisionApp> {
  final store = Store<AppState>(appStateReducer,
      initialState: init(),
      middleware: [loggingMiddleware, navigationMiddleware, homeMiddleware]);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _checkFirstTime() async {
    final SharedPreferences prefs = await _prefs;
    Shared.isFirstTime = prefs.getBool('AmkenahFirstTime') ?? true;
    prefs.setBool('AmkenahFirstTime', false);
  }

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          theme:
              ThemeData(fontFamily: 'Ubuntu', primaryColor: Colors.blue[900]),
          initialRoute: '/',
          navigatorKey: navigatorKey,
          title: "Valid Vision",
          builder: (context, child) {
            return Builder(
              builder: (context) {
                return MediaQuery(
                  child: child,
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                );
              },
            );
          },
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: routes(),
        ));
  }
}
