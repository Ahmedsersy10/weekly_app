// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_background_container.dart';
import 'package:weekly_dash_board/views/widgets/incom_section_body.dart';
import 'package:weekly_dash_board/views/widgets/incom_section_header.dart';

class IncomeSection extends StatelessWidget {
  const IncomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBackgroundContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [IncomSectionHeader(), IncomSectionBody()],
      ),
    );
  }
}
