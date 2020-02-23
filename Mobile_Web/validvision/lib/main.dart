import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/routes.dart';

import 'modules/core/middleware/home_middleware.dart';
import 'modules/core/middleware/navigation_key.dart';
import 'modules/core/middleware/navigation_middleware.dart';
import 'modules/core/models/app_state.dart';
import 'modules/core/reducers/app_state_reducer.dart';
import 'modules/core/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bool isInDebugMode = false;
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned<Future<Null>>(() async {
    runApp(ValidVisionApp());
  }, onError: (error, stackTrace) async {
    print("Error: " + error.toString());
    print(stackTrace.toString());
  });
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

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
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
