// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

class IncomChart extends StatefulWidget {
  const IncomChart({super.key});

  @override
  State<IncomChart> createState() => _IncomChartState();
}

class _IncomChartState extends State<IncomChart> {
  int activeIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1, child: PieChart(getChartData()));
  }

  PieChartData getChartData() {
    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (event, response) {
          activeIndex = response?.touchedSection?.touchedSectionIndex ?? -1;

          setState(() {});
        },
      ),
      sectionsSpace: 0,
      sections: [
        PieChartSectionData(
          value: 40,
          showTitle: false,
          color: const Color(0xff208bc7),
          radius: activeIndex == 0 ? 40 : 30,
        ),
        PieChartSectionData(
          value: 25,
          showTitle: false,
          color: const Color(0xff4db7f2),
          radius: activeIndex == 1 ? 40 : 30,
        ),
        PieChartSectionData(
          value: 20,
          showTitle: false,
          color: const Color(0xff064060),
          radius: activeIndex == 2 ? 40 : 30,
        ),
        PieChartSectionData(
          value: 22,
          showTitle: false,
          color: const Color(0xffe2decd),
          radius: activeIndex == 3 ? 40 : 30,
        ),
      ],
    );
  }
}
