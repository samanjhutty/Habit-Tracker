import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyWidgets extends ChangeNotifier {
  bool timerEnabled = true;
  int timerSeconds = 30;

  defaultSubmitBtn(
          {String title = 'Next',
          IconData icon = Icons.arrow_forward_rounded}) =>
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(title), const SizedBox(width: 8), Icon(icon)]);

  myAnimation(
      {String title = 'Next',
      IconData icon = Icons.arrow_forward_rounded,
      bool progress = false}) {
    Widget btn = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(title),
      const SizedBox(width: 8),
      progress == false
          ? Icon(icon)
          : const SizedBox(
              height: 24, width: 24, child: CircularProgressIndicator())
    ]);
    notifyListeners();
    return btn;
  }

  mySnackbar(String text) async {
    Get.closeAllSnackbars();
    Get.rawSnackbar(message: text);
  }

  timer() {
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timerSeconds != 0) {
        timerSeconds--;
        notifyListeners();
      } else {
        timerEnabled = false;
        notifyListeners();
      }
    });
    return timer;
  }
}
