import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/actions/open_home_screen_action.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeNameFirst = FocusNode();
  final FocusNode myFocusNodeNameSecond = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameFirstController = TextEditingController();
  TextEditingController signupNameSecondController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupSpecialityController = TextEditingController();
  PageController _pageController;
  bool isDoctor = false;
  Color left = Colors.white;
  Color right = Colors.blue[900];
  List<File> _importedImages = List<File>();

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
        builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
                return;
              },
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height >= 775.0
                      ? MediaQuery.of(context).size.height
                      : 775.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.blue[300]],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Image(
                            height: 160.0,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/logo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: _buildMenuBar(context),
                      ),
                      Expanded(
                        flex: 2,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) {
                            if (i == 0) {
                              setState(() {
                                right = Colors.blue[900];
                                left = Colors.white;
                              });
                            } else if (i == 1) {
                              setState(() {
                                right = Colors.white;
                                left = Colors.blue[900];
                              });
                            }
                          },
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: Container(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 4.0,
                                      color: Colors.white,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 15.0,
                                                bottom: 10.0,
                                                left: 15.0,
                                                right: 15.0),
                                            child: TextField(
                                              focusNode: myFocusNodeNameFirst,
                                              controller:
                                                  signupNameFirstController,
                                              onEditingComplete: () =>
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          myFocusNodeNameSecond),
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.blue[900]),
                                              decoration: InputDecoration(
                                                  alignLabelWithHint: true,
                                                  icon: Icon(Icons.person,
                                                      color: Colors.blue[900]),
                                                  hintText: "Full Name"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 15.0,
                                                right: 15.0),
                                            child: TextField(
                                              focusNode: myFocusNodeEmail,
                                              controller: signupEmailController,
                                              onEditingComplete: () =>
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          myFocusNodePassword),
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.blue[900]),
                                              decoration: InputDecoration(
                                                  icon: Icon(Icons.email,
                                                      color: Colors.blue[900]),
                                                  hintText: "Email"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 15.0,
                                                right: 15.0),
                                            child: TextField(
                                              focusNode: myFocusNodePassword,
                                              controller:
                                                  signupPasswordController,
                                              obscureText: _obscureTextSignup,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.blue[900]),
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.lock,
                                                  color: Colors.blue[900],
                                                ),
                                                hintText: "Password",
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 15.0,
                                                right: 15.0),
                                            child: Row(
                                              children: <Widget>[
                                                Switch(
                                                    value: isDoctor,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        isDoctor = val;
                                                      });
                                                      if (!val) {
                                                        setState(() {
                                                          signupSpecialityController
                                                              .clear();
                                                          _importedImages
                                                              .clear();
                                                        });
                                                      }
                                                    },
                                                    activeColor:
                                                        Colors.blue[900],
                                                    activeTrackColor:
                                                        Colors.blue[300]),
                                                VerticalDivider(),
                                                Text(
                                                  "I'm a Doctor",
                                                  style: TextStyle(
                                                      color: isDoctor
                                                          ? Colors.blue[600]
                                                          : Colors.black,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (isDoctor)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 5.0,
                                                  left: 15.0,
                                                  right: 15.0),
                                              child: Text(
                                                  "Upload license to practice the profession and the card of the Medical Association",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue)),
                                            ),
                                          if (isDoctor)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  left: 15.0,
                                                  right: 15.0),
                                              child: Row(
                                                children: <Widget>[
                                                  RaisedButton(
                                                    onPressed:
                                                        _importedImages.length <
                                                                2
                                                            ? () {}
                                                            : null,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(Icons.attach_file,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(width: 10),
                                                        Text("Attach Documents",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white))
                                                      ],
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    elevation: 1,
                                                    color: Colors.blue[900],
                                                  ),
                                                  if (_importedImages.length >
                                                      0)
                                                    GestureDetector(
                                                      onTap: () {
                                                        return showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical: SizeConfig
                                                                              .safeBlockVertical,
                                                                          horizontal:
                                                                              SizeConfig.safeBlockHorizontal * 2),
                                                                      actions: <
                                                                          Widget>[
                                                                        Center(
                                                                          child:
                                                                              RaisedButton(
                                                                            color:
                                                                                Colors.blue[700],
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                                            child:
                                                                                Text(
                                                                              "Done",
                                                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Images",
                                                                          style: TextStyle(
                                                                              color: Colors.blue[900],
                                                                              fontSize: 16),
                                                                        ),
                                                                      ),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8)),
                                                                      content: ListView(
                                                                          shrinkWrap:
                                                                              true,
                                                                          children: [
                                                                            GridView.count(
                                                                                shrinkWrap: true,
                                                                                crossAxisCount: 3,
                                                                                crossAxisSpacing: 1.0,
                                                                                mainAxisSpacing: 2.0,
                                                                                children: _importedImages.map((File image) {
                                                                                  return Stack(alignment: Alignment.topRight, children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.all(8),
                                                                                      child: Image.file(image, height: 60),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      child: Icon(Icons.cancel, color: Colors.red[800]),
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          _importedImages.removeAt(_importedImages.indexOf(image));
                                                                                        });
                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                    ),
                                                                                  ]);
                                                                                }).toList()),
                                                                          ]),
                                                                    ));
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blue[900],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                          _importedImages.length
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue[900]),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: MaterialButton(
                                          highlightColor: Colors.transparent,
                                          splashColor: Colors.blue[300],
                                          //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 40.0),
                                            child: Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            showProgress(ctx);
                                            Timer(Duration(seconds: 3), () {
                                              cancelProgress(ctx);
                                              store.dispatch(
                                                  OpenHomeScreenAction());
                                            });

//                                            if (signupEmailController
//                                                    .value.text.isEmpty ||
//                                                !validateEmail(
//                                                    signupEmailController
//                                                        .value.text)) {
//                                              showInSnackBar(
//                                                  "من فضلك أدخل بريد إلكترونى صالح");
//                                            } else if (signupNameFirstController
//                                                    .value.text.isEmpty ||
//                                                signupNameSecondController
//                                                    .value.text.isEmpty) {
//                                              showInSnackBar(
//                                                  "من فضلك تأكد من إدخال الاسم الأول والأخير");
//                                            } else if (signupNameFirstController
//                                                        .value.text.length <
//                                                    3 ||
//                                                signupNameSecondController
//                                                        .value.text.length <
//                                                    3) {
//                                              showInSnackBar(
//                                                  "من فضلك تأكد من إدخال الاسم الأول والأخير كاملين");
//                                            } else if (signupPasswordController
//                                                    .value.text.isEmpty ||
//                                                signupPasswordController
//                                                        .value.text.length <
//                                                    8) {
//                                              showInSnackBar(
//                                                  "من فضلك تأكد من إدخال كلمة مرور صالحة تتكون من 8 حروف أو أكثر");
//                                            } else {
//                                              store.dispatch(SignUpAction(
//                                                  email: signupEmailController
//                                                      .value.text,
//                                                  password:
//                                                      signupPasswordController
//                                                          .value.text,
//                                                  firstName:
//                                                      signupNameFirstController
//                                                          .value.text,
//                                                  secondName:
//                                                      signupNameSecondController
//                                                          .value.text,
//                                                  context: context));
//                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.expand(),
                              child: Container(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      elevation: 4.0,
                                      color: Colors.white,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15.0,
                                                  bottom: 10.0,
                                                  left: 15.0,
                                                  right: 15.0),
                                              child: TextField(
                                                focusNode:
                                                    myFocusNodeEmailLogin,
                                                controller:
                                                    loginEmailController,
                                                onEditingComplete: () => FocusScope
                                                        .of(context)
                                                    .requestFocus(
                                                        myFocusNodePasswordLogin),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.blue[900]),
                                                decoration: InputDecoration(
                                                    icon: Icon(Icons.email,
                                                        color:
                                                            Colors.blue[900]),
                                                    hintText: "Email"),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 20.0,
                                                  left: 15.0,
                                                  right: 15.0),
                                              child: TextField(
                                                focusNode:
                                                    myFocusNodePasswordLogin,
                                                controller:
                                                    loginPasswordController,
                                                obscureText: _obscureTextLogin,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.blue[900]),
                                                decoration: InputDecoration(
                                                  icon: Icon(Icons.lock,
                                                      color: Colors.blue[900]),
                                                  hintText: "Password",
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              padding: EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 20.0,
                                                  left: 15.0,
                                                  right: 15.0),
                                              child: Text(
                                                "Forget Password?",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blue[700]),
                                              ),
                                              onPressed: () {},
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 40.0),
                                      decoration: new BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      child: MaterialButton(
                                          highlightColor: Colors.transparent,
                                          splashColor:
                                              Colors.blue.withOpacity(0.5),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 40.0),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          onPressed: () {
                                            showProgress(ctx);
                                            Timer(Duration(seconds: 3), () {
                                              cancelProgress(ctx);
                                              store.dispatch(
                                                  OpenHomeScreenAction());
                                            });

//                                            if (loginEmailController
//                                                    .value.text.isEmpty ||
//                                                !validateEmail(
//                                                    loginEmailController
//                                                        .value.text)) {
//                                              showInSnackBar(
//                                                  "من فضلك أدخل بريد إلكترونى صالح");
//                                            } else if (loginPasswordController
//                                                    .value.text.isEmpty ||
//                                                loginPasswordController
//                                                        .value.text.length <
//                                                    8) {
//                                              showInSnackBar(
//                                                  "من فضلك تأكد من إدخال كلمة مرور صالحة تتكون من 8 حروف أو أكثر");
//                                            } else {
//                                              store.dispatch(LoginAction(
//                                                  context: context,
//                                                  password:
//                                                      loginPasswordController
//                                                          .value.text,
//                                                  email: loginEmailController
//                                                      .value.text));
//                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeNameFirst.dispose();
    myFocusNodeNameSecond.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 18.0,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 2),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "SignUp",
                  style: TextStyle(
                      color: right,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: left, fontWeight: FontWeight.w600, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (regex.hasMatch(value))
      return true;
    else
      return false;
  }

  Future<bool> _onWillPop(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "إغلاق",
              style: TextStyle(color: Colors.red[700]),
            ),
            content: Text("هل تريد بالفعل إغلاق التطبيق؟"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("لا"),
                textColor: Colors.white,
                color: Colors.green[700],
              ),
              FlatButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                color: Colors.red,
                textColor: Colors.white,
                child: Text("نعم"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class TabIndicationPainter extends CustomPainter {
  Paint painter;
  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  final PageController pageController;

  TabIndicationPainter(
      {this.dxTarget = 125.0,
      this.dxEntry = 25.0,
      this.radius = 21.0,
      this.dy = 25.0,
      this.pageController})
      : super(repaint: pageController) {
    painter = new Paint()
      ..color = Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final pos = pageController.position;
    double fullExtent =
        (pos.maxScrollExtent - pos.minScrollExtent + pos.viewportDimension);

    double pageOffset = pos.extentBefore / fullExtent;

    bool left2right = dxEntry < dxTarget;
    Offset entry = new Offset(left2right ? dxEntry : dxTarget, dy);
    Offset target = new Offset(left2right ? dxTarget : dxEntry, dy);

    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
        new Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);

    canvas.translate(size.width * pageOffset, 0.0);
    canvas.drawShadow(path, Colors.blue[900], 3.0, true);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(TabIndicationPainter oldDelegate) => true;
}
