import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/actions/open_home_screen_action.dart';
import 'package:validvision/modules/core/middleware/navigation_key.dart';
import 'package:validvision/modules/core/models/app_state.dart';

import '../../size_config.dart';
import 'clip_painter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailKey = TextEditingController();
  var _passwordKey = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool passwordIsShown = false;

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
        builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
                child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                overflow: Overflow.clip,
                children: <Widget>[
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: Container(
                          child: Transform.rotate(
                        angle: -pi / 3.5,
                        child: ClipPath(
                          clipper: ClipPainter(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.blue[900],
                                  Colors.lightBlueAccent,
                                  Colors.lightBlueAccent,
                                  Colors.blue[900]
                                ])),
                            child: Container(
                              height: SizeConfig.safeBlockVertical * 10,
                            ),
                          ),
                        ),
                      ))),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontFamily: "Ubuntu",
                              fontSize: SizeConfig.safeBlockVertical * 6),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 2,
                                color: Colors.blue[900],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 4),
                          margin: EdgeInsets.only(
                              right: SizeConfig.safeBlockHorizontal * 4,
                              left: SizeConfig.safeBlockHorizontal * 4,
                              bottom: SizeConfig.safeBlockVertical * 2,
                              top: SizeConfig.safeBlockVertical * 8),
                          child: TextFormField(
                              validator: (value) {
                                bool emailValid = RegExp(
                                        "[a-z0-9!#\$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter a valid email';
                                } else
                                  return null;
                              },
                              controller: _emailKey,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  border: InputBorder.none,
                                  hintText: "example@mail.com",
                                  icon: Icon(
                                    Icons.mail,
                                    size: SizeConfig.safeBlockVertical * 4,
                                    color: Colors.blue[900],
                                  ))),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                width: 2,
                                color: Colors.blue[900],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 4),
                          margin: EdgeInsets.only(
                              right: SizeConfig.safeBlockHorizontal * 4,
                              left: SizeConfig.safeBlockHorizontal * 4,
                              top: SizeConfig.safeBlockVertical * 2,
                              bottom: SizeConfig.safeBlockVertical * 8),
                          child: TextFormField(
                              validator: (value) {
                                if (value.length > 6) {
                                  return 'Too short password';
                                } else
                                  return null;
                              },
                              controller: _passwordKey,
                              obscureText: !passwordIsShown,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  border: InputBorder.none,
                                  suffix: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          passwordIsShown = !passwordIsShown;
                                        });
                                      },
                                      child: passwordIsShown
                                          //hide
                                          ? Image.asset(
                                              'assets/hide_password.png',
                                              width: 20,
                                              fit: BoxFit.scaleDown,
                                              color: Colors.blue[900],
                                            )
                                          //show
                                          : Image.asset(
                                              'assets/show_password.png',
                                              fit: BoxFit.scaleDown,
                                              width: 20,
                                              color: Colors.blue[900],
                                            )),
                                  hintText: "******",
                                  icon: Icon(
                                    Icons.lock_outline,
                                    size: SizeConfig.safeBlockVertical * 4,
                                    color: Colors.blue[900],
                                  ))),
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 20,
                              vertical: SizeConfig.safeBlockVertical),
                          onPressed: () {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              elevation: 10,
                              backgroundColor: Colors.blue[900],
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.cyan),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.safeBlockHorizontal * 4,
                                        vertical: SizeConfig.safeBlockVertical),
                                  ),
                                  Text(
                                    "Signing in...",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockVertical * 3),
                                  )
                                ],
                              ),
                              duration: Duration(seconds: 3),
                            ));
                            Timer(Duration(seconds: 4), () {
                              store.dispatch(OpenHomeScreenAction());
                            });
                          },
                          color: Colors.blue[900],
                          child: Text(
                            "login",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 4,
                                color: Colors.white),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                          height: SizeConfig.safeBlockVertical * 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical * 2.6),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigatorKey.currentState.pop();
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.8,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))),
      );
    });
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Are you sure?",
              style: TextStyle(color: Colors.blue[900]),
            ),
            content: Text("Are you want to close Valid Vision?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
                textColor: Colors.white,
                color: Colors.green,
              ),
              FlatButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
