import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../controller/cloud/cloud_constants.dart';
import '../../controller/db_controller.dart';
import '../../controller/local/db_constants.dart';
import '../../controller/time_controller.dart';
import '../../model/habit_model.dart';
import '../pages/add_habit.dart';

class HabitTile extends StatefulWidget {
  const HabitTile({super.key});

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    user != null ? _getCloudList() : _getList();
    super.initState();
  }

  _getList() async {
    DbController db = context.read<DbController>();

    try {
      List list = await box.get(BoxConstants.habitListKeyText +
              DbController.habbitListKey(DateTime.now())) ??
          <HabitModel>[];

      List localList = list.map((e) => e as HabitModel).toList();
      setState(() {
        db.habitList = localList.cast<HabitModel>();
      });
      print('list loaded from box');
    } catch (e) {
      print('Unexpected error occured: $e');
    }
  }

  _getCloudList() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DbController db = context.read<DbController>();
    try {
      var snapshot = await firestore
          .collection(CloudConstants.collections)
          .doc(CloudConstants.docName + user!.uid)
          .get();

      List dataMap = snapshot.data()!.containsKey(
              CloudConstants.habitListKeyText +
                  DbController.habbitListKey(DateTime.now()))
          ? snapshot.get(CloudConstants.habitListKeyText +
              DbController.habbitListKey(DateTime.now()))
          : [];

      List<Map<String, dynamic>> habitListMap =
          dataMap.cast<Map<String, dynamic>>();

      for (Map<String, dynamic> element in habitListMap) {
        setState(() {
          db.habitList.add(HabitModel.fromMap(element));
        });
      }
      print('list loaded from cloud');
    } catch (e) {
      print('Unexpected error occured: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView.builder(
        itemCount: context.watch<DbController>().habitList.length,
        itemBuilder: ((context, index) {
          return context.watch<DbController>().habitList.isEmpty
              ? const Center(
                  child: Text(
                    "No habbit maintained, let's build a new one!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              : Consumer<DbController>(builder: (context, db, child) {
                  HabitModel list = db.habitList[index];
                  if (list.completed == true) {
                    list.initialHabbitTime = list.totalHabbitTime;
                  }

                  double percentCompleted =
                      (list.initialHabbitTime! + list.elapsedTime!) /
                          list.totalHabbitTime!;

                  double initialTime = list.totalHabbitTime! -
                      (list.initialHabbitTime! + list.elapsedTime!);

                  String remainingInitialTime = initialTime > 60
                      ? '${TimeController().formatedTime((initialTime / 60).floor(), (((list.totalHabbitTime! / 60) - (list.totalHabbitTime! / 60).floor()) * 60).toInt())} hrs'
                      : '${initialTime.ceil()} min';

                  String totalTime = list.totalHabbitTime! > 60
                      ? '${TimeController().formatedTime((list.totalHabbitTime! / 60).floor(), (((list.totalHabbitTime! / 60) - (list.totalHabbitTime! / 60).floor()) * 60).toInt())} hrs'
                      : '${list.totalHabbitTime!.ceil()} min';

                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          minVerticalPadding: 0,
                          leading: Tooltip(
                            message: list.running == true ? 'Pause' : 'Play',
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () =>
                                  db.habitOnTap(context: context, index: index),
                              child: Stack(
                                fit: StackFit.passthrough,
                                alignment: Alignment.center,
                                children: [
                                  list.running == true
                                      ? const Icon(Icons.pause)
                                      : const Icon(Icons.play_arrow),
                                  CircularPercentIndicator(
                                    progressColor: scheme.primary,
                                    backgroundColor: scheme.secondary,
                                    lineWidth: 4,
                                    radius: 24,
                                    percent: percentCompleted <= 1
                                        ? percentCompleted
                                        : 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          title: Text(list.title!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20)),
                          subtitle: Text(
                              'Remaining  $remainingInitialTime / $totalTime',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                          trailing: PopupMenuButton(
                            tooltip: 'Settings',
                            position: PopupMenuPosition.under,
                            child: const Icon(Icons.settings),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddHabit(
                                              data: list, index: index))),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Edit')
                                    ],
                                  )),
                              PopupMenuItem(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actionsPadding:
                                                const EdgeInsets.only(
                                                    right: 16, bottom: 16),
                                            title: const Text('Delete Habbit'),
                                            content: const Text(
                                                'Are you sure you want to delete this habbit?'),
                                            actions: [
                                              IconButton.filled(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  icon: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: scheme.onPrimary,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )),
                                              IconButton.outlined(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                onPressed: () async {
                                                  setState(() {
                                                    db.habitList
                                                        .removeAt(index);
                                                  });
                                                  db.saveUpdatedList();
                                                  Navigator.pop(context);
                                                },
                                                icon: const Text('Delete'),
                                              )
                                            ],
                                          )),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: scheme.error,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Delete'),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ));
                });
        }));
  }
}
