// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/latest_transcton_list_view.dart';

class LatestTranscton extends StatelessWidget {
  const LatestTranscton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latest Transcton', style: AppStyles.styleMedium16(context)),
        const SizedBox(height: 16),
        const LatestTransctonListView(),
      ],
    );
  }
}
