// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/all_expenses_Item_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/all_expenses_item_header.dart';

class ActiveAllExpensesItem extends StatelessWidget {
  const ActiveAllExpensesItem({super.key, required this.itemModel});

  final AllExpensesItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: const Color(0xff4db7f2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 1, color: Color(0xfff1f1f1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AllExpensesItemHeader(
            image: itemModel.image,
            colorbackgroundImage: Colors.white.withOpacity(0.1000000149011612),
            colorImage: Colors.white,
            colorIcon: Colors.white,
          ),
          const SizedBox(height: 34),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              itemModel.title,
              style: AppStyles.styleSemiBold16(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,

            child: Text(
              itemModel.date,
              // ignore: use_full_hex_values_for_flutter_colors
              style: AppStyles.styleRegular14(
                context,
              ).copyWith(color: const Color(0xffffafafa)),
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,

            child: Text(
              itemModel.price,
              style: AppStyles.styleSemiBold24(
                context,
              ).copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
