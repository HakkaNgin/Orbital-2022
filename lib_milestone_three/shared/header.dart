import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, required String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: false,
    // automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "FlutterShare" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 50.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}