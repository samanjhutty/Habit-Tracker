import 'package:hive_flutter/hive_flutter.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel {
  HabitModel(
      {required this.title,
      required this.initialHabbitTime,
      required this.elapsedTime,
      required this.totalHabbitTime,
      required this.running,
      required this.completed});

  @HiveField(0)
  String? title;

  @HiveField(1)
  double? initialHabbitTime;

  @HiveField(2)
  double? elapsedTime;

  @HiveField(3)
  double? totalHabbitTime;

  @HiveField(4)
  bool? running;

  @HiveField(5)
  bool? completed;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['title'] = title;
    map['initialHabbitTime'] = initialHabbitTime;
    map['elapsedTime'] = elapsedTime;
    map['totalHabbitTime'] = totalHabbitTime;
    map['running'] = running;
    map['completed'] = completed;
    return map;
  }

  HabitModel.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    initialHabbitTime = map['initialHabbitTime'];
    elapsedTime = map['elapsedTime'];
    totalHabbitTime = map['totalHabbitTime'];
    running = map['running'];
    completed = map['completed'] ?? false;
  }
}
