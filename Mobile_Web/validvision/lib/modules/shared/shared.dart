import 'package:redux/redux.dart';
import 'package:validvision/modules/core/models/app_state.dart';

class Shared {
  static String loginToken;
  static String deviceToken;
  static Store<AppState> globalStore;

  static bool isFirstTime;
}
