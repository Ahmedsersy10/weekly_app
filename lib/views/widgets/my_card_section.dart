// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/views/widgets/dots_indicator.dart';
import 'package:weekly_dash_board/views/widgets/my_card_page_view.dart';

class MyCardsSection extends StatefulWidget {
  const MyCardsSection({super.key});

  @override
  State<MyCardsSection> createState() => _MyCardsSectionState();
}

class _MyCardsSectionState extends State<MyCardsSection> {
  late PageController pageController;
  int currentPageIndex = 0;

  @override
  void initState() {
    pageController = PageController();

    pageController.addListener(() {
      currentPageIndex = pageController.page!.round();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text('My card', style: AppStyles.styleSemiBold20(context)),
        ),
        const SizedBox(height: 20),
        MyCardPageView(pageController: pageController),
        const SizedBox(height: 20),
        DotsIndicator(currentPage: currentPageIndex),
      ],
    );
  }
}
