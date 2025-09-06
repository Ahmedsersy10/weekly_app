import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/widgets/custom_button.dart';
import 'package:weekly_dash_board/core/widgets/custom_button_model.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_form_field.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do\neiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                  style: AppStyles.styleRegular12(context),
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  title: 'Password',
                  hintText: ' *************',
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Confirm Password ',
                  hintText: ' *************',
                ),
                const SizedBox(height: 44),
                CustomButton(
                  title: 'New Password',
                  customButtonModel: CustomButtonModel(
                    text: 'New Password',
                    buttonColor: AppColors.maroon,
                    textColor: AppColors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
