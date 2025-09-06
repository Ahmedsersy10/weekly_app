// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/user_info_model.dart';
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/views/widgets/user_info_list_tile.dart';

class LatestTransctonListView extends StatelessWidget {
  const LatestTransctonListView({super.key});
  static const items = [
    UserInfoModel(
      image: Assets.imagesAvatar1,
      title: 'Ahmedelsersy',
      subTitle: 'ahmedelsersy@gmail.com',
    ),
    UserInfoModel(
      image: Assets.imagesAvatar2,
      title: 'Ahmedelsersy',
      subTitle: 'ahmedelsersy@gmail.com',
    ),
    UserInfoModel(
      image: Assets.imagesAvatar3,
      title: 'Ahmedelsersy',
      subTitle: 'ahmedelsersy@gmail.com',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return IntrinsicWidth(
            child: UserInfoListTile(userInfoModel: items[index]),
          );
        },
      ),
    );
  }
}
