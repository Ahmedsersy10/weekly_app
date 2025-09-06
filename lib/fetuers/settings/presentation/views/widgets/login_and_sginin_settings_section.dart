import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/widgets/custom_button.dart';
import 'package:weekly_dash_board/core/widgets/custom_button_model.dart';
import 'package:weekly_dash_board/fetuers/settings/presentation/views/widgets/settings_section.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/log_in_view.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/sign_up_view.dart';

class LoginAndSgininSettingsSection extends StatelessWidget {
  const LoginAndSgininSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Sin In Or Sign Up',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              title: 'Sin In',
              width: 150,
              customButtonModel: CustomButtonModel(
                text: 'Sin In',
                buttonColor: AppColors.maroon,
                textColor: AppColors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LogInView()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            CustomButton(
              title: 'Sign Up',
              width: 150,
              customButtonModel: CustomButtonModel(
                text: 'Sign Up',
                buttonColor: AppColors.maroon,
                textColor: AppColors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
