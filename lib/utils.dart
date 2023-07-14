import 'package:flutter/material.dart';

import 'main.dart';

class Utils{
  static showSnacBar(String? text){
    if(text == null)
      return;
    final snackBar = SnackBar(
        content: Text(text),
      backgroundColor: Colors.deepOrangeAccent,
    );
    messengerKey.currentState!
    ..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
  static showSuccessSnackBar(String? text){
    if(text == null)
      return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.lightGreen,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}