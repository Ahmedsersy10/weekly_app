// Flutter imports:
import 'package:flutter/material.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/statistics_dashboard_widget.dart';
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/custom_background_container.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/dashbord_tablet_layout.dart';

class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 3, child: DashbordTabletLayout()),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 0),
            child: CustomBackgroundContainer(child: StatisticsDashboardWidget()),
          ),
        ),
      ],
    );
  }
}
