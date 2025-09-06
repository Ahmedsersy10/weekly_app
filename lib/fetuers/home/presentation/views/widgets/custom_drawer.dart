import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(backgroundColor: AppColors.white);
  }
}
