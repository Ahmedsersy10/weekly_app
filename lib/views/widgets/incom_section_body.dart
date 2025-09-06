// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/incom_chart.dart';
import 'package:weekly_dash_board/views/widgets/incom_details_list_view.dart';

class IncomSectionBody extends StatelessWidget {
  const IncomSectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return width >= SizeConfig.desktop && width < 1551
        ? const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [IncomDetailsList(), SizedBox(height: 24), IncomChart()],
          )
        : const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: IncomChart()),
              SizedBox(width: 16),
              Expanded(flex: 2, child: IncomDetailsList()),
            ],
          );
  }
}
