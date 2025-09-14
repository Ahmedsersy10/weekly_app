import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/sign_up_view_body.dart';
import 'package:weekly_dash_board/core/constants/app_color.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sign Up', style: AppStyles.styleSemiBold24(context)),
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: const SignUpViewBody(),
    );
  }
}
