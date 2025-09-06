import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/achievement_section.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/user_guide_section.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/contact_section.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/rate_share_section.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/about_section.dart';
import 'package:weekly_dash_board/fetuers/more/presentation/widgets/statistics_dashboard_widget.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).tr('app.more'),
          style: AppStyles.styleSemiBold24(
            context,
          ).copyWith(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Dashboard
            StatisticsDashboardWidget(),
            SizedBox(height: 24),

            // Achievement Statistics Section
            AchievementSection(),
            SizedBox(height: 24),

            // User Guide Section
            UserGuideSection(),
            SizedBox(height: 24),

            // Contact Us Section
            ContactSection(),
            SizedBox(height: 24),

            // Rate & Share Section
            RateShareSection(),
            SizedBox(height: 24),

            // About App Section
            AboutSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
