// Flutter imports:
import 'package:flutter/material.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/root_view.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_contaner_weekly_of.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_view_days.dart';

class DashbordLayoutMobile extends StatefulWidget {
  const DashbordLayoutMobile({super.key});

  @override
  State<DashbordLayoutMobile> createState() => _DashbordLayoutMobileState();
}

class _DashbordLayoutMobileState extends State<DashbordLayoutMobile> {
  final Map<int, GlobalKey> _dayKeys = {for (int i = 0; i < 6; i++) i: GlobalKey()};
  @override
  Widget build(BuildContext context) {
    return const RootView();
  }

  void scrollToDay(int dayIndex) {
    final key = _dayKeys[dayIndex];
    if (key == null) return;
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}
