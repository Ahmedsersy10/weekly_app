// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable_page_view/expandable_page_view.dart';

// Project imports:
import 'package:weekly_dash_board/views/widgets/my_card.dart';

class MyCardPageView extends StatelessWidget {
  const MyCardPageView({super.key, required this.pageController});
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: pageController,

      children: List.generate(
        3,
        (i) =>
            const Padding(padding: EdgeInsets.only(right: 16), child: MyCard()),
      ),
    );
  }
}
