// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/drawer_item_model.dart';
import 'package:weekly_dash_board/models/user_info_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/views/widgets/in_active_drawer_item.dart';
import 'package:weekly_dash_board/views/widgets/list_view_drawer_item.dart';
import 'package:weekly_dash_board/views/widgets/user_info_list_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: UserInfoListTile(
                userInfoModel: UserInfoModel(
                  image: Assets.imagesAvatar3,
                  title: 'Ahmed elsersy',
                  subTitle: 'ahmedelsersy10@gmail.com',
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 8)),
            ListViewDrawerItem(),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(child: SizedBox(height: 20)),
                  inActiveDrawerItem(
                    drawerItemModel: DrawerItemModel(
                      title: 'Setting system',
                      image: Assets.imagesSettings,
                    ),
                  ),
                  inActiveDrawerItem(
                    drawerItemModel: DrawerItemModel(
                      title: 'Logout account',
                      image: Assets.imagesLogout,
                    ),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
