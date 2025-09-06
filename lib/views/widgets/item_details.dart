// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/item_details_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.itemDetailsModel});
  final ItemDetailsModel itemDetailsModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        itemDetailsModel.title,
        style: AppStyles.styleRegular16(context),
      ),
      leading: Container(
        width: 12,
        height: 12,
        decoration: ShapeDecoration(
          shape: const OvalBorder(),
          color: itemDetailsModel.color,
        ),
      ),
      trailing: Text(
        itemDetailsModel.value,
        style: AppStyles.styleMedium16(context),
      ),
    );
  }
}
