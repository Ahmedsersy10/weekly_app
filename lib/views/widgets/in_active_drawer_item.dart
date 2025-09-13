// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';

import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';

class inActiveDrawerItem extends StatelessWidget {
  const inActiveDrawerItem({super.key, required this.drawerItemModel});
  final DrawerItemModel drawerItemModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(drawerItemModel.image, color: AppColors.primary),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of(context).tr(drawerItemModel.title),
          style: AppStyles.styleRegular16(
            context,
          ).copyWith(color: const Color.fromARGB(255, 71, 67, 67)),
        ),
      ),
    );
  }
}
