import 'package:flutter/material.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_card_home_view.dart';

class CustomListViewDays extends StatelessWidget {
  final Map<int, GlobalKey> dayKeys;
  const CustomListViewDays({
    super.key,
    this.dayKeys = const <int, GlobalKey>{},
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final key = dayKeys[index] ?? ValueKey('day_$index');
        return Container(
          key: key,
          child: CustomCardHomeView(dayIndex: index),
        );
      },
      itemCount: 6, // Saturday to Thursday (6 days), Friday is day off
    );
  }
}
