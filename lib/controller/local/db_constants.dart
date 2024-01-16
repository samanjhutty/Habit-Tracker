import 'dart:core';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;

class BoxConstants {
  ///Box specific Key
  static const boxName = 'Habit-Tracker';

  ///Global Keys
  static const startDateKey = 'APP-START-DATE';
  static const appThemeColorValue = 'App-Theme';

  /// For each individual habit
  static const habitListKeyText = 'HabitList-day:';
  static const habitSummaryText = 'Habit-Summary:';
}
