// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/util/app_style.dart';

class ActiveDrawerItem extends StatelessWidget {
  const ActiveDrawerItem({super.key, required this.drawerItemModel});
  final DrawerItemModel drawerItemModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(drawerItemModel.image),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          drawerItemModel.title,
          style: AppStyles.styleBold16(context),
        ),
      ),
      trailing: Container(width: 3.27, color: const Color(0xFF4EB7F2)),
    );
  }
}
