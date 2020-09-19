import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';

class Shared {
  static String loginToken;
  static String deviceToken;
  static Store<AppState> globalStore;

  static bool isFirstTime;
}

Future<Null> showProgress(BuildContext context) {
  var dialog = showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 18,
                        decoration: TextDecoration.none),
                  ),
                )
              ],
            ),
          ),
        );
      });
  return dialog;
}

Future<Null> cancelProgress(BuildContext context) {
  Navigator.of(context).pop();
  return null;
}
