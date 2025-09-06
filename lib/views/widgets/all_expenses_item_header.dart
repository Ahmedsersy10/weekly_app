// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';

class AllExpensesItemHeader extends StatelessWidget {
  const AllExpensesItemHeader({
    super.key,
    required this.image,
    this.colorImage,
    this.colorbackgroundImage,
    this.colorIcon,
  });
  final String image;
  final Color? colorImage, colorbackgroundImage, colorIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 60, maxWidth: 60),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: ShapeDecoration(
                  shape: const OvalBorder(),
                  color: colorbackgroundImage ?? const Color(0xfff1f1f1),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    image,
                    colorFilter: ColorFilter.mode(
                      colorImage ?? const Color(0xff4eb7f2),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: colorIcon ?? const Color(0xFF064061),
        ),
      ],
    );
  }
}
