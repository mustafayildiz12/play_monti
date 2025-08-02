import 'package:flutter/material.dart';
import 'package:play_monti/models/user_model.dart';



class UserProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
} 