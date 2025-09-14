import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:weekly_dash_board/core/constants/app_color.dart';
import 'package:weekly_dash_board/fetuers/splash/presentation/views/widgets/gif_image_splash_view.dart';
import 'package:weekly_dash_board/views/dashboard_view.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late final GifController _controller;
  @override
  void initState() {
    super.initState();
    navigateToHome();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GifImageSplashView(controller: _controller),
      backgroundColor: AppColors.surface,
    );
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    });
  }
}
