import 'package:flutter/material.dart';

class LeSnack {
  GlobalKey<ScaffoldState> _key;
  GlobalKey<ScaffoldState> get key => _key;

  LeSnack() {
    _key = GlobalKey<ScaffoldState>();
  }

  void showMessage(String message,
      {int durationMillis = 2000, bool removeCurrentSnack = true, double elevation = 6.0}) {
    if (removeCurrentSnack) {
      _key.currentState.removeCurrentSnackBar();
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: durationMillis),
      elevation: elevation,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
    _key.currentState.showSnackBar(snackBar);
  }
}
