// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_images.dart';
import 'package:weekly_dash_board/util/app_style.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 420 / 215,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xff4eb7f2),
          image: const DecorationImage(
            image: AssetImage(Assets.imagesCardBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(
                left: 31,
                right: 41,
                top: 8,
              ),
              title: Text(
                'Name Card',
                style: AppStyles.styleRegular16(
                  context,
                ).copyWith(color: Colors.white),
              ),
              subtitle: Text(
                'Syah Bandi',
                style: AppStyles.styleSemiBold20(
                  context,
                ).copyWith(color: Colors.white),
              ),
              trailing: SvgPicture.asset(Assets.imagesGallery),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0918 8124 0042 8129',
                    style: AppStyles.styleSemiBold24(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                  Text(
                    '12/20 - 124',
                    style: AppStyles.styleRegular16(
                      context,
                    ).copyWith(color: const Color(0xffFFFFFF)),
                  ),
                ],
              ),
            ),
            const Flexible(child: SizedBox(height: 26)),
          ],
        ),
      ),
    );
  }
}
