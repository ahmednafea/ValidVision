import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/actions/open_home_screen_action.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      onInitialBuild: (Store<AppState> store) async {
        Shared.globalStore = store;
        Timer(Duration(seconds: 3), () {
          store.dispatch(OpenHomeScreenAction());
        });
      },
      builder: (BuildContext ctx, Store<AppState> store) {
        SizeConfig().init(context);
        return Scaffold(
            key: scaffoldKey,
            body: Material(
                color: Colors.white,
                child: Container(
                    child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockHorizontal * 5,
                            vertical: SizeConfig.safeBlockVertical * 5),
                        child: Image.asset("assets/logo.png"),
                      ),
                      Text(
                        "welcome",
                        style: TextStyle(
                            color: Color(0xff0066d8),
                            fontSize: SizeConfig.safeBlockVertical * 5,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ))));
      },
    );
  }
}
