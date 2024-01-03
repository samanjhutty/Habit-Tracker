import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MonthSummary extends StatefulWidget {
  const MonthSummary(
      {super.key, required this.startDate, required this.dataset});

  final DateTime startDate;
  final Map<DateTime, int> dataset;
  @override
  State<MonthSummary> createState() => _MonthSummaryState();
}

class _MonthSummaryState extends State<MonthSummary> {
  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: HeatMap(
        startDate: widget.startDate,
        endDate: DateTime.now(),
        defaultColor: scheme.secondary,
        datasets: widget.dataset,
        colorMode: ColorMode.opacity,
        textColor: Colors.grey,
        showText: true,
        showColorTip: false,
        scrollable: false,
        colorsets: {1: scheme.primary},
        size: 30,
      ),
    );
  }
}
