import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';

import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';

class ActiveDrawerItem extends StatelessWidget {
  const ActiveDrawerItem({super.key, required this.drawerItemModel});
  final DrawerItemModel drawerItemModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(drawerItemModel.image, color: AppColors.maroon),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of(context).tr(drawerItemModel.title),
          style: AppStyles.styleBold16(
            context,
          ).copyWith(color: AppColors.maroon),
        ),
      ),
      trailing: Container(width: 3.27, color: AppColors.maroon),
    );
  }
}
