// Flutter imports:
import 'package:flutter/material.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_drawer.dart';
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/adaptive_layout.dart';
import 'package:weekly_dash_board/views/widgets/dashboard_desktop_layout.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_layout_mobile.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_tablet_layout.dart';

// Project imports:

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width < SizeConfig.tablet
            ? AppBar(
                backgroundColor: const Color(0xfffafafa),
                elevation: 0,
                foregroundColor: Colors.black,
              )
            : null,
        drawer: MediaQuery.of(context).size.width < SizeConfig.tablet
            ? const CustomDrawer()
            : null,
        backgroundColor: const Color(0xffE5E5E5),
        body: AdaptiveLayout(
          mobileLayout: (context) => const DashbordLayoutMobile(),
          tabletLayout: (context) => const DashbordTabletLayout(),
          desktopLayout: (context) => const DashboardDesktopLayout(),
        ),
      ),
    );
  }
}
