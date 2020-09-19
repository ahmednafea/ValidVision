import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/middleware/navigation_key.dart';
import 'package:validvision/modules/core/models/app_state.dart';
import 'package:validvision/modules/shared/shared.dart';

import '../../size_config.dart';

class HomeScreen extends StatefulWidget {
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  bool analyzed = false;
  int _selectedIndex = 1;

  Future _capturePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.path);
    setState(() {
      analyzed = false;
      _image = image;
    });
  }

  Future _importImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.path);
    setState(() {
      analyzed = false;
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
        builder: (BuildContext ctx, Store<AppState> store) {
      SizeConfig().init(context);
      return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.white)]),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    gap: 2,
                    activeColor: Colors.blue[700],
                    iconSize: 24,
                    textStyle: TextStyle(fontSize: 16, color: Colors.blue[800]),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 800),
                    tabBackgroundColor: Colors.white,
                    tabs: [
                      GButton(
                        icon: Icons.history,
                        text: 'History',
                      ),
                      GButton(
                        icon: Icons.shutter_speed,
                        text: 'Detect',
                      ),
                      GButton(
                        icon: Icons.settings,
                        text: 'Setting',
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    color: Colors.blue[200],
                  ),
                ),
              ),
            ),
            body: currentWidget(store, ctx, _selectedIndex)),
      );
    });
  }

  Widget currentWidget(Store<AppState> store, BuildContext ctx, int index) {
    switch (index) {
      case 0:
        return Center(
          child: Text(
            "History hadn't been added yet.",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700]),
          ),
        );
      case 1:
        return Center(
          child: Column(
            children: <Widget>[
              Container(
                  height: 600,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _image == null
                      ? Text(
                          'No image selected',
                          style:
                              TextStyle(color: Colors.blue[900], fontSize: 18),
                        )
                      : Column(
                          children: <Widget>[
                            Image.file(
                              _image,
                              height: 200,
                              fit: BoxFit.scaleDown,
                            ),
                            SizedBox(height: 20),
                            if (analyzed)
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.red, width: 4)),
                                child: Image.asset(
                                  "assets/final_img.jpg",
                                  height: 200,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            if (analyzed) SizedBox(height: 20),
                            if (analyzed)
                              Text(
                                "80% has Cataract",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              )
                          ],
                        )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _capturePhoto,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                        Padding(
                          child: Text(
                            "Capture Photo",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          padding: EdgeInsets.only(left: 10),
                        )
                      ],
                    ),
                    color: Colors.blue[900],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: _importImage,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue[900],
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        Padding(
                          child: Text(
                            "Import Image",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          padding: EdgeInsets.only(left: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                onPressed: _image != null
                    ? () {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          elevation: 10,
                          backgroundColor: Colors.blue[900].withOpacity(0.8),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.cyan),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              Text(
                                "Detecting...",
                                style: TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                          duration: Duration(seconds: 12),
                        ));
                        Timer(Duration(seconds: 12), () {
                          setState(() {
                            analyzed = true;
                          });
                        });
                      }
                    : null,
                color: Colors.blue[900],
                child: Text(
                  "Start Detection",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        );
      case 2:
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 40, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            "assets/person.png",
                            fit: BoxFit.scaleDown,
                            height: 120,
                            color: Colors.blue[900],
                          )),
                    ],
                  )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Ahmed Nafea",
                        style: TextStyle(color: Colors.blue[700], fontSize: 22),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FlatButton(
                  onPressed: () {
                    showProgress(ctx);
                    Timer(Duration(seconds: 2), () {
                      cancelProgress(ctx);
                      navigatorKey.currentState.pop();
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.blue[700]),
                      SizedBox(width: 10),
                      Text(
                        "Log Out",
                        style: TextStyle(fontSize: 18, color: Colors.blue[900]),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1.2,
                color: Colors.blue[100],
              )
            ],
          ),
        );
    }
    return Container();
  }
}
