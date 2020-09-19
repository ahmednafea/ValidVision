import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';

Future<http.Response> fetchAlbum() {
  return http
      .get('http://192.168.1.2:5000/api/v1/resources/books/all', headers: {
    HttpHeaders.contentTypeHeader: "application/json",
  });
}

homeMiddleware(Store<AppState> store, action, NextDispatcher next) async {
//  if (action is OpenWelcomeScreenAction) {
//    fetchAlbum().then((value) => print(value.body));
//  } else {
//    next(action);
//  }
  next(action);
}
