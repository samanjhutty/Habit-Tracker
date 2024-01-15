import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';

import '../../controller/cloud/cloud_constants.dart';
import '../../controller/db_controller.dart';

class MonthSummary extends StatefulWidget {
  const MonthSummary({super.key});

  @override
  State<MonthSummary> createState() => _MonthSummaryState();
}

class _MonthSummaryState extends State<MonthSummary> {
  bool? loadHeatmap = false;
  DateTime? startDate;
  DbController controller = DbController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    user != null ? _getStartDateCloud() : _getStartDateBox();
    _loadHeatMap();
    super.initState();
  }

  _getStartDateCloud() async {
    var firestore =
        FirebaseFirestore.instance.collection(CloudConstants.collections);

    var snapshot =
        await firestore.doc(CloudConstants.docName + user!.uid).get();
    startDate = DbController.habbitListKeytoDateTime(
            snapshot.get(CloudConstants.startDateKey)) ??
        DbController.habbitListKey(DateTime.now());
    setState(() {});
  }

  _getStartDateBox() {
    startDate = DbController.habbitListKeytoDateTime(
        DbController.habbitListKey(DateTime.now()));
    setState(() {});
  }

  _loadHeatMap() async {
    await controller.percentCompleted();
    await controller.loadHeatMap();
    loadHeatmap = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: startDate == null && loadHeatmap == false
          ? const Center(child: CircularProgressIndicator())
          : Consumer<DbController>(builder: (context, db, child) {
              return HeatMap(
                startDate: startDate,
                endDate: DateTime.now(),
                defaultColor: scheme.secondary,
                datasets: db.heatMapDataset,
                colorMode: ColorMode.opacity,
                textColor: Colors.white70,
                showText: true,
                showColorTip: false,
                scrollable: false,
                colorsets: {1: scheme.primary},
                size: 30,
              );
            }),
    );
  }
}
