// Flutter imports:
import 'package:flutter/material.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_contaner_weekly_of.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_view_days.dart';
import 'package:weekly_dash_board/util/size_config.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_drawer.dart';

class DashbordTabletLayout extends StatefulWidget {
  const DashbordTabletLayout({super.key});

  @override
  State<DashbordTabletLayout> createState() => _DashbordTabletLayoutState();
}

class _DashbordTabletLayoutState extends State<DashbordTabletLayout> {
  final Map<int, GlobalKey> _dayKeys = {for (int i = 0; i < 6; i++) i: GlobalKey()};

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: CustomDrawer()),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: CustomContainerWeeklyOf(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    MediaQuery.of(context).size.width < SizeConfig.desktop
                        ? CustomListViewDays(dayKeys: _dayKeys)
                        : const CustomGridViewDays(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
