import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/controller/local/db_constants.dart';
import 'package:habit_tracker/model/habit_model.dart';

class DbController extends GetxController {
  List<HabitModel> habitList = <HabitModel>[];
  Map<DateTime, int> heatMapDataset = {};

  void refreshdb() => update();
  newHabit(
      {required String title,
      required double totalTime,
      required bool isStart}) async {
    habitList.add(HabitModel(
        title: title,
        initialHabbitTime: 0.0,
        elapsedTime: 0.0,
        totalHabbitTime: totalTime,
        running: isStart,
        completed: false));
    await box.put(BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
        habitList);
    print('habit added');
    update();
  }

  updateHabit(
      {required int index,
      required String title,
      required double initilTime,
      required double elapsedTime,
      required double totalTime,
      required String listDayKey,
      required bool isStart}) async {
    habitList[index] = HabitModel(
        title: title,
        initialHabbitTime: initilTime,
        elapsedTime: elapsedTime,
        totalHabbitTime: totalTime,
        running: isStart,
        completed: initilTime == totalTime ? true : false);
    await box.put(listDayKey, habitList);
    print('habit updated');

    update();
  }

  Future myTimePicker({required context}) async {
    var time = await showTimePicker(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: kDebugMode
            ? const TimeOfDay(hour: 0, minute: 1)
            : const TimeOfDay(hour: 1, minute: 0));
    return time;
  }

  static String habbitListKey(DateTime date) {
    String year = date.year.toString();
    String month =
        date.month.isLowerThan(10) ? '0${date.month}' : date.month.toString();
    String day =
        date.day.isLowerThan(10) ? '0${date.day}' : date.day.toString();

    return year + month + day;
  }

  static habbitListKeytoDateTime(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));

    return DateTime(year, month, day);
  }

  habitOnTap({required int index}) async {
    double totalTime = habitList[index].totalHabbitTime;

    habitList[index].running = !habitList[index].running;
    // update();  //show a bug(timer goes forward and back to previous)
    if (habitList[index].running) {
      habitList[index].elapsedTime += habitList[index].initialHabbitTime;
    }

    if (habitList[index].initialHabbitTime + habitList[index].elapsedTime >=
        totalTime) {
      habitList[index].running = false;
      showDialog(
          context: navigator!.context,
          builder: (context) => AlertDialog(
                title: const Text('Reset Habit'),
                content: const Text(
                    "You've alrealy completed this habit, would you like to reset it?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        habitList[index].initialHabbitTime = 0;
                        habitList[index].elapsedTime = 0;
                        update();

                        navigator!.pop();
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        navigator!.pop();
                      },
                      child: const Text('No'))
                ],
              ));
    }
    DateTime time = DateTime.now();
    print('completed: ${habitList[index].completed}');
    if (habitList[index].running) {
      Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
        if (habitList[index].running == false) {
          // print(
          //     'time running: ${habitList[index].elapsedTime.toStringAsFixed(2)}');
          await box.put(
              BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
              habitList);
          timer.cancel();
          update();
        } else if (habitList[index].initialHabbitTime +
                    habitList[index].elapsedTime >=
                totalTime ||
            habitList[index].completed == true) {
          habitList[index].initialHabbitTime = habitList[index].totalHabbitTime;
          habitList[index].running = false;
          habitList[index].completed = true;

          // show notification
          percentCompleted();
          loadHeatMap();
          update();
          await box.put(
              BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
              habitList);
          print('list updated');
          timer.cancel();
          Get.rawSnackbar(message: 'Habbit completed');
        } else {
          var time2 = DateTime.now();

          habitList[index].initialHabbitTime =
              ((time2.difference(time).inSeconds) / 60).toDouble();
          update();
          // print(
          //     'total time ${habitList[index].title}: ${habitList[index].initialHabbitTime.toStringAsFixed(2)}');
        }
      });
    }
  }

  Future<void> percentCompleted() async {
    double completed = 0.0;
    for (int i = 0; i < habitList.length; i++) {
      if (habitList[i].completed == true) {
        completed++;
      }
    }
    double percentSummary =
        habitList.isNotEmpty ? completed / habitList.length : 0.0;
    await box.put(BoxConstants.habitSummaryText + habbitListKey(DateTime.now()),
        percentSummary);
    print('Percent completed: $percentSummary');
  }

  void loadHeatMap() async {
    DateTime date = habbitListKeytoDateTime(box.get(BoxConstants.startDateKey));

    int dayInBW = DateTime.now().difference(date).inDays;
    for (int i = 0; i <= dayInBW; i++) {
      double strength =
          box.get(BoxConstants.habitSummaryText + habbitListKey(date)) ?? 0.0;

      int year = date.year;
      int month = date.month;
      int day = date.day;
      final summary = <DateTime, int>{
        DateTime(year, month, day): (strength * 10).toInt()
      };

      heatMapDataset.addEntries(summary.entries);
      print('loop ran, entries: ${heatMapDataset.entries}');
      date = date.add(const Duration(days: 1));
    }
  }
}
