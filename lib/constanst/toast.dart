import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToastSuccess(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.blueAccent,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showCustomToastErrors(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    backgroundColor: const Color.fromARGB(255, 175, 8, 8),
    textColor: Colors.white,
    fontSize: 16.0,
    webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
  );
}
