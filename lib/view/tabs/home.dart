import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    startDate = DbController.habbitListKeytoDateTime(
        DbController.habbitListKey(DateTime.now()));
    super.initState();
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
                  startDate: startDate!,
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
