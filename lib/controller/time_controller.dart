import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeController {
  String formatedDateTimeObj(TimeOfDay time) {
    String hrs =
        time.hour.isLowerThan(10) ? '0${time.hour}' : time.hour.toString();
    String min = time.minute.isLowerThan(10)
        ? '0${time.minute}'
        : time.minute.toString();
    return '$hrs : $min';
  }

  String formatedTime(int hour, int minute) {
    String newMin = minute.isLowerThan(10) ? '0$minute' : minute.toString();
    return '$hour : $newMin';
  }

  double timeOfDayToDouble(TimeOfDay time) {
    double hrs = time.hour * 60;
    double min = time.minute.toDouble();

    return hrs + min;
  }

  TimeOfDay doubleToTimeOfDay(double totalMin) {
    int hrs = totalMin > 60 ? (totalMin / 60).floor() : 0;
    int min = totalMin > 60 ? (totalMin - 60).ceil() : totalMin.ceil();

    return TimeOfDay(hour: hrs, minute: min);
  }
}
