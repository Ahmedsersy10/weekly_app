import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/log_in_view_body.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Log In', style: AppStyles.styleSemiBold24(context)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const LogInViewBody(),
    );
  }
}
