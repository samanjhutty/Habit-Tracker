import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/assets/asset_widgets.dart';
import 'package:habit_tracker/controller/cloud/cloud_constants.dart';
import 'package:habit_tracker/controller/local/db_constants.dart';
import 'package:habit_tracker/model/habit_model.dart';

class DbController extends ChangeNotifier {
  List<HabitModel> habitList = <HabitModel>[];
  Map<DateTime, int> heatMapDataset = {};
  final firestore =
      FirebaseFirestore.instance.collection(CloudConstants.collections);
  final User? _user = FirebaseAuth.instance.currentUser;
  MyWidgets myWidgets = MyWidgets();

  ///Refreshes the controller again if not auto refreshed,
  ///only to be used as a last resort if anything else doesn't work.
  // void reRefresh() {
  //   notifyListeners();
  // }

  ///Get the list saved in user's database.
  ///only to be used when logging in, not to invoke when app starts or builds
  ///for a seamless experience.
  getFirestoreList() async {
    try {
      var snapshot =
          await firestore.doc(CloudConstants.docName + _user!.uid).get();
      List dataMap = snapshot.data()!.containsKey(
              CloudConstants.habitListKeyText +
                  DbController.habbitListKey(DateTime.now()))
          ? snapshot.get(CloudConstants.habitListKeyText +
              DbController.habbitListKey(DateTime.now()))
          : [];

      List<Map<String, dynamic>> habitListMap =
          dataMap.cast<Map<String, dynamic>>();

      for (Map<String, dynamic> element in habitListMap) {
        habitList.add(HabitModel.fromMap(element));
        notifyListeners();
      }
    } catch (e) {
      Get.rawSnackbar(message: 'Internet connection is not stable');
    }
  }

  ///Saves the provided theme color in local storage,
  ///and also notifies all listners.
  void changeTheme(Color themeColor) {
    box.put(BoxConstants.appThemeColorValue, themeColor.value);
    notifyListeners();
  }

  ///Save all the local saved values to Cloud Firestore.
  void syncToCloud(BuildContext context) async {
    myWidgets.mySnackbar('This may take sometime...');

    if (box.isNotEmpty) {
      for (int index = 0; index < box.length; index++) {
        await firestore.doc(CloudConstants.docName + _user!.uid).set(
            {'${box.keyAt(index)}': box.getAt(index)}, SetOptions(merge: true));
      }
      myWidgets.mySnackbar('All data is synced to cloud');
    } else {
      myWidgets.mySnackbar('No entries found in local storage');
    }
  }

  ///update List on Changes to Databse,
  ///not to call when updating list items, only call when secondary function is perform like deleting a habit. So that it can save changes to db.
  void saveUpdatedList() async {
    _user != null
        ? await firestore.doc(CloudConstants.docName + _user.uid).set(
            toMap(
                CloudConstants.habitListKeyText + habbitListKey(DateTime.now()),
                habitListToMap(habitList)),
            SetOptions(merge: true))
        : await box.put(
            BoxConstants.habitListKeyText +
                DbController.habbitListKey(DateTime.now()),
            habitList);

    notifyListeners();
  }

  ///Return a Map to store values to firestore.
  Map<String, dynamic> toMap(String key, dynamic data) => {key: data};

  ///Converts a List<HabitModel> to List of Map<String, dynamic>.
  ///
  ///helps in storing values to firestore.
  List<Map<String, dynamic>> habitListToMap(List<HabitModel> habitList) {
    List<Map<String, dynamic>> mapList = [];
    for (HabitModel element in habitList) {
      Map<String, dynamic> map = element.toMap();
      mapList.add(map);
    }

    return mapList;
  }

  ///Add a new Habit to Database.
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
    _user != null
        ? await firestore.doc(CloudConstants.docName + _user.uid).set(
            toMap(
                CloudConstants.habitListKeyText + habbitListKey(DateTime.now()),
                habitListToMap(habitList)),
            SetOptions(merge: true))
        : await box.put(
            BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
            habitList);
    notifyListeners();
  }

  ///Update existing Habit in Database.
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
    _user != null
        ? await firestore.doc(CloudConstants.docName + _user.uid).set(
            toMap(listDayKey, habitListToMap(habitList)),
            SetOptions(merge: true))
        : await box.put(listDayKey, habitList);
    notifyListeners();
  }

  ///Returns a DateTime picker Widget.
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

  ///Converts Datetime object to a String of Integers containing date, eg :20240101,
  ///helps in storing to db.
  static String habbitListKey(DateTime date) {
    String year = date.year.toString();
    String month =
        date.month.isLowerThan(10) ? '0${date.month}' : date.month.toString();
    String day =
        date.day.isLowerThan(10) ? '0${date.day}' : date.day.toString();

    return year + month + day;
  }

  ///Converts String of Integers to a Datetime object,
  ///helps in getting date from db.
  static habbitListKeytoDateTime(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6, 8));

    return DateTime(year, month, day);
  }

  ///Action to perform on Habit play/pause button tap
  habitOnTap({required BuildContext context, required int index}) async {
    double totalTime = habitList[index].totalHabbitTime!;

    habitList[index].running = !habitList[index].running!;
    // notifyListeners();  //show a bug(timer goes forward and back to previous)
    if (habitList[index].running!) {
      habitList[index].elapsedTime =
          habitList[index].elapsedTime! + habitList[index].initialHabbitTime!;
    }

    if (habitList[index].initialHabbitTime! + habitList[index].elapsedTime! >=
        totalTime) {
      habitList[index].running = false;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Reset Habit'),
                content: const Text(
                    "You've alrealy completed this habit, would you like to reset it?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        habitList[index].initialHabbitTime = 0;
                        habitList[index].elapsedTime = 0;
                        habitList[index].completed = false;
                        notifyListeners();

                        Navigator.pop(context);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'))
                ],
              ));
    }
    DateTime time = DateTime.now();
    if (habitList[index].running!) {
      Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
        if (habitList[index].running == false) {
          _user != null
              ? await firestore.doc(CloudConstants.docName + _user.uid).set(
                  toMap(
                      CloudConstants.habitListKeyText +
                          habbitListKey(DateTime.now()),
                      habitListToMap(habitList)),
                  SetOptions(merge: true))
              : await box.put(
                  BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
                  habitList);
          timer.cancel();
          notifyListeners();
        } else if (habitList[index].initialHabbitTime! +
                    habitList[index].elapsedTime! >=
                totalTime ||
            habitList[index].completed == true) {
          habitList[index].initialHabbitTime = habitList[index].totalHabbitTime;
          habitList[index].running = false;
          habitList[index].completed = true;

          // show notification
          notifyHabit();
          await percentCompleted();
          await loadHeatMap();
          notifyListeners();
          _user != null
              ? await firestore.doc(CloudConstants.docName + _user.uid).set(
                  toMap(
                      CloudConstants.habitListKeyText +
                          habbitListKey(DateTime.now()),
                      habitListToMap(habitList)),
                  SetOptions(merge: true))
              : await box.put(
                  BoxConstants.habitListKeyText + habbitListKey(DateTime.now()),
                  habitList);
          timer.cancel();
          myWidgets.mySnackbar('Habbit completed');
        } else {
          var time2 = DateTime.now();

          habitList[index].initialHabbitTime =
              ((time2.difference(time).inSeconds) / 60).toDouble();
          notifyListeners();
        }
      });
    }
  }

  ///Notifies when a habit is Compeleted.
  void notifyHabit() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'Habit-Completed',
            title: 'Habit Completed',
            body: 'Congrats!, you have sucessfully completed a habit'));
  }

  ///Percentage completed of each day Habit List for Heatmap
  Future<void> percentCompleted() async {
    double completed = 0.0;
    for (int i = 0; i < habitList.length; i++) {
      if (habitList[i].completed == true) {
        completed++;
      }
    }
    double percentSummary =
        habitList.isNotEmpty ? completed / habitList.length : 0.0;
    _user != null
        ? await firestore.doc(CloudConstants.docName + _user.uid).set(
            toMap(
                CloudConstants.habitSummaryText + habbitListKey(DateTime.now()),
                percentSummary),
            SetOptions(merge: true))
        : await box.put(
            BoxConstants.habitSummaryText + habbitListKey(DateTime.now()),
            percentSummary);
  }

  ///Heatmap enteries for graph
  loadHeatMap() async {
    var doc = _user != null
        ? await firestore.doc(CloudConstants.docName + _user.uid).get()
        : null;
    DateTime date = habbitListKeytoDateTime(doc != null
        ? doc.get(CloudConstants.startDateKey)
        : box.get(BoxConstants.startDateKey));

    int dayInBW = DateTime.now().difference(date).inDays;
    for (int i = 0; i <= dayInBW; i++) {
      double strength = doc != null
          ? doc.data()!.containsKey(
                  CloudConstants.habitSummaryText + habbitListKey(date))
              ? double.tryParse(doc
                  .get(CloudConstants.habitSummaryText + habbitListKey(date))
                  .toString())
              : 0
          : box.get(BoxConstants.habitSummaryText + habbitListKey(date),
              defaultValue: 0);

      int year = date.year;
      int month = date.month;
      int day = date.day;
      final summary = <DateTime, int>{
        DateTime(year, month, day): (strength * 10).toInt()
      };

      heatMapDataset.addEntries(summary.entries);
      date = date.add(const Duration(days: 1));
    }
    notifyListeners();
  }
}
