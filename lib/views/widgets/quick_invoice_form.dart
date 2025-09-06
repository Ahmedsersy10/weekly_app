// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/custom_button.dart';
import 'package:weekly_dash_board/views/widgets/title_text_field.dart';

class QuickInvoiceForm extends StatelessWidget {
  const QuickInvoiceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TitleTextField(
                title: 'Invoice Number',
                hintText: 'Type Invoice Number',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TitleTextField(
                title: 'Invoice Date',
                hintText: 'Type Invoice Date',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TitleTextField(
                title: 'Invoice Number',
                hintText: 'Type Invoice Number',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TitleTextField(
                title: 'Invoice Date',
                hintText: 'Type Invoice Date',
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          spacing: 24,
          children: [
            Expanded(
              child: CustomButton(
                text: 'Add more details',
                buttonColor: Colors.white,
                textColor: Color(0xff4db7f2),
              ),
            ),
            Expanded(child: CustomButton()),
          ],
        ),
      ],
    );
  }
}
