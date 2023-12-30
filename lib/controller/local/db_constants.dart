import 'dart:core';
import 'package:hive_flutter/hive_flutter.dart';

late Box box;

class BoxConstants {
  static const boxName = 'Habit-Tracker';
  static const startDateKey = 'APP-START-DATE';

  // For each individual habit
  static const habitListKeyText = 'HabitList-day:';
  static const habitSummaryText = 'Habit-Summary';
}
