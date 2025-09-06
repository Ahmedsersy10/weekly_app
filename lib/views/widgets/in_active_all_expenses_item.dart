// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/all_expenses_Item_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/all_expenses_item_header.dart';

class InActiveAllExpensesItem extends StatelessWidget {
  const InActiveAllExpensesItem({super.key, required this.itemModel});

  final AllExpensesItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 1, color: Color(0xfff1f1f1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllExpensesItemHeader(image: itemModel.image),
          const SizedBox(height: 34),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              itemModel.title,
              style: AppStyles.styleSemiBold16(context),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              itemModel.date,
              style: AppStyles.styleRegular14(context),
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              itemModel.price,
              style: AppStyles.styleSemiBold24(context),
            ),
          ),
        ],
      ),
    );
  }
}
