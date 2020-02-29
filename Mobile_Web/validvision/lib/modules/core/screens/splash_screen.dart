import 'dart:async';

import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/identity/actions/open_welcome_screen_action.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      onInitialBuild: (Store<AppState> store) async {
        Shared.globalStore = store;
        Timer(Duration(seconds: 4), () {
          store.dispatch(OpenWelcomeScreenAction());
        });
      },
      builder: (BuildContext ctx, Store<AppState> store) {
        SizeConfig().init(context);
        return Scaffold(
            key: scaffoldKey,
            body: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 4,
                      horizontal: SizeConfig.safeBlockHorizontal * 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: SizeConfig.safeBlockVertical * 60,
                        height: SizeConfig.safeBlockVertical * 60,
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical * 4),
                        child: FlareActor("assets/logo.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: "Aura"),
                      ),
                      Expanded(
                        child: Text(
                          "Valid Vision",
                          style: TextStyle(
                            color: Color(0xff0066d8),
                            fontFamily: "Arabolical",
                            fontSize: SizeConfig.safeBlockVertical * 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
      },
    );
  }
}
