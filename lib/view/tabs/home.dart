import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/controller/cloud/cloud_constants.dart';
import 'package:provider/provider.dart';
import '../../controller/db_controller.dart';
import '../widgets/habit_tile.dart';
import '../widgets/month_summary.dart';

class MyHomeTab extends StatefulWidget {
  const MyHomeTab({super.key});

  final String title = 'Keep focus in check';
  final String subtitle = 'Keep track of your habbit everyday';
  @override
  State<MyHomeTab> createState() => _MyHomeTabState();
}

class _MyHomeTabState extends State<MyHomeTab> {
  DateTime? startDate;
  var firestore =
      FirebaseFirestore.instance.collection(CloudConstants.collections);
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _getStartDate();
    super.initState();
  }

  _getStartDate() async {
    if (user != null) {
      var snapshot =
          await firestore.doc(CloudConstants.docName + user!.uid).get();
      startDate = DbController.habbitListKeytoDateTime(
              snapshot.get(CloudConstants.startDateKey)) ??
          DbController.habbitListKey(DateTime.now());
    } else {
      startDate = DbController.habbitListKeytoDateTime(
          DbController.habbitListKey(DateTime.now()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ColorScheme scheme = Theme.of(context).colorScheme;
    Size device = MediaQuery.of(context).size;

    double graphHeight = device.height * 0.4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(graphHeight),
            child: SizedBox(
              height: graphHeight,
              child: Consumer<DbController>(builder: (context, db, child) {
                return MonthSummary(
                  startDate: startDate ?? DateTime.now(),
                  dataset: db.heatMapDataset,
                );
              }),
            ),
          ),
          toolbarHeight: 80,
          title: ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            title: Text(widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            subtitle: Text(widget.subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ),
        body: const HabitTile(),
      ),
    );
  }
}
