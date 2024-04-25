import 'package:flutter/material.dart';

AppBar createAppbar(String appbarTitle) {
  return AppBar(
    title: Text(appbarTitle),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 3,
  );
}
