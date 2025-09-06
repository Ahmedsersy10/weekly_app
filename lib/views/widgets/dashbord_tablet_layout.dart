// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_drawer.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_layout_mobile.dart';

class DashbordTabletLayout extends StatelessWidget {
  const DashbordTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: CustomDrawer()),
        SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: DashbordLayoutMobile(),
          ),
        ),
        SizedBox(width: 24),
      ],
    );
  }
}
