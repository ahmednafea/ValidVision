import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/identity/actions/open_welcome_screen_action.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class OpenerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenerScreenState();
}

class _OpenerScreenState extends State<OpenerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = PageController();
  bool _finish = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(onInitialBuild: (Store<AppState> store) {
      setState(() {
        Shared.isFirstTime = false;
      });
    }, builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _finish
                  ? Container()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: FlatButton(
                        onPressed: () {
                          store.dispatch(OpenWelcomeScreenAction());
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: SizeConfig.safeBlockVertical * 3),
                        ),
                      ),
                    ),
              Container(
                height: SizeConfig.safeBlockVertical * 70,
                child: PageView(
                    controller: _controller,
                    onPageChanged: (pageNo) {
                      setState(() {
                        pageNo == 3 ? _finish = true : _finish = false;
                      });
                    },
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(colors: <Color>[
                                  Colors.blue[600],
                                  Colors.blue[900]
                                ])),
                            padding:
                                EdgeInsets.all(SizeConfig.safeBlockVertical),
                            margin: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Image.asset("assets/healthy_eye.png",
                                fit: BoxFit.scaleDown,
                                height: SizeConfig.safeBlockVertical * 15,
                                width: SizeConfig.safeBlockVertical * 25),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Text("Healthy Eye",
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical * 4,
                                    color: Color(0xff003399))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 6),
                            child: Text(
                                "Keep your eyes healthy by constantly checking with our app.",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.8,
                                    color: Colors.blue[800])),
                          )
                        ],
                      ),
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0)),
                            margin: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Image.asset("assets/take_pic.png",
                                fit: BoxFit.scaleDown,
                                height: SizeConfig.safeBlockVertical * 25),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Text("Take A Picture",
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical * 4,
                                    color: Color(0xff003399))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 6),
                            child: Text(
                                "With just one photo, you'll get an accurate diagnosis of the health of your eyes.",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.8,
                                    color: Colors.blue[800])),
                          )
                        ],
                      )),
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0)),
                            margin: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Image.asset(
                              "assets/ai_vision.jpg",
                              fit: BoxFit.scaleDown,
                              height: SizeConfig.safeBlockVertical * 25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Text("AI Power",
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical * 4,
                                    color: Color(0xff003399))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 6),
                            child: Text(
                                "By utilizing the power of artificial intelligence you will get the best results in the shortest possible time.",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.8,
                                    color: Colors.blue[800])),
                          ),
                        ],
                      )),
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Image.asset("assets/doctors.png",
                                fit: BoxFit.scaleDown,
                                height: SizeConfig.safeBlockVertical * 25),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.safeBlockVertical * 4),
                            child: Text("Confirmed Results",
                                style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical * 4,
                                    color: Color(0xff003399))),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 6),
                            child: Text(
                                "The results coming from the system are reviewed by qualified doctors to obtain a confirmed diagnosis.",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.safeBlockVertical * 2.8,
                                    color: Colors.blue[800])),
                          ),
                        ],
                      )),
                    ]),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _finish
                        ? GestureDetector(
                            onTap: () {
                              store.dispatch(OpenWelcomeScreenAction());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.safeBlockVertical * 2,
                                  horizontal:
                                      SizeConfig.safeBlockHorizontal * 10),
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.safeBlockVertical * 3,
                                ),
                              ),
                              alignment: FractionalOffset.center,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54, blurRadius: 5.0)
                                  ],
                                  borderRadius: BorderRadius.circular(30.0),
                                  gradient: LinearGradient(colors: <Color>[
                                    Colors.blue[900],
                                    Colors.lightBlueAccent
                                  ])),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical * 12),
                            child: SmoothPageIndicator(
                              controller: _controller,
                              count: 4,
                              effect: WormEffect(),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
