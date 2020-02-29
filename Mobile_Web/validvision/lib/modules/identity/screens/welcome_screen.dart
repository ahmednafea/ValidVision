import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/identity/actions/open_login_screen_action.dart';
import 'package:validvision/modules/identity/actions/open_signup_screen_action.dart';

import '../../size_config.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget _submitButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xfff7892b)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Quick login with Touch ID',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.fingerprint, size: 90, color: Colors.white),
            SizedBox(
              height: 20,
            ),
            Text(
              'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
        builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 4,
                vertical: SizeConfig.safeBlockVertical * 6),
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[50], Colors.blue[900]])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  height: SizeConfig.safeBlockVertical * 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.safeBlockVertical * 22,
                      top: SizeConfig.safeBlockVertical * 4),
                  child: Text(
                    "Valid Vision",
                    style: TextStyle(
                      color: Color(0xff0066d8),
                      fontFamily: "Arabolical",
                      fontSize: SizeConfig.safeBlockVertical * 6,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    store.dispatch(OpenLoginScreenAction());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 2,
                        horizontal: SizeConfig.safeBlockHorizontal * 8),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockVertical * 3,
                      ),
                    ),
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 3.0)
                        ],
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(colors: <Color>[
                          Colors.blue[900],
                          Colors.lightBlueAccent
                        ])),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    store.dispatch(OpenSignUpScreenAction());
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.safeBlockVertical * 8),
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 2,
                        horizontal: SizeConfig.safeBlockHorizontal * 8),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockVertical * 3,
                      ),
                    ),
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black54, blurRadius: 3.0)
                        ],
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(colors: <Color>[
                          Colors.blue[900],
                          Colors.lightBlueAccent
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
