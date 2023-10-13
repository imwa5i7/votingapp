import 'package:disney_voting/config/constants.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:flutter/material.dart';

class BaseController extends ChangeNotifier {
  States states = States.initial(Constants.initial);

  setState(States state) {
    states = state;
    notifyListeners();
  }

  init() {
    states == States.initial(Constants.initial);
  }
}
