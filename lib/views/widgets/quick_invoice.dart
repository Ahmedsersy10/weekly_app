// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/custom_background_container.dart';
import 'package:weekly_dash_board/views/widgets/latest_transcton.dart';
import 'package:weekly_dash_board/views/widgets/quick_invoice_form.dart';
import 'package:weekly_dash_board/views/widgets/quick_invoice_header.dart';

class QuickInvoice extends StatelessWidget {
  const QuickInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomBackgroundContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuickInvoiceHeader(),
          LatestTranscton(),
          Divider(height: 24, color: Color(0xfff1f1f1)),
          QuickInvoiceForm(),
        ],
      ),
    );
  }
}
