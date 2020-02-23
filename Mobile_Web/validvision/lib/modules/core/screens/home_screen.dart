import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class HomeScreen extends StatefulWidget {
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(onInit: (Store<AppState> store) {
      Shared.globalStore = store;
    }, builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("home"),
          centerTitle: true,
        ),
        body: Container(),
      );
    });
  }
}
