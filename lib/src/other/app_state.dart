import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppState extends ChangeNotifier {
  bool _showLogin = false;
  bool _showActivation = false;

  bool get showLogin => _showLogin;

  bool get showActivation => _showActivation;

  updateShowLogin(bool status) {
    _showLogin = status;
    notifyListeners();
  }

  updateShowActivation(bool status) {
    _showActivation = status;
    notifyListeners();
  }
}

var drawerStatus = 0.0.obs;
