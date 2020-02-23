import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';

homeMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);
}
