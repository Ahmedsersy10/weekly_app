import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/core/util/app_theme.dart';
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
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: colorScheme.onSurface,
            fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 24),
          ),
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
            StatisticsDashboardWidget(),
            SizedBox(height: 24),

            AchievementSection(),
            SizedBox(height: 24),

            UserGuideSection(),
            SizedBox(height: 24),

            ContactSection(),
            SizedBox(height: 24),

            RateShareSection(),
            SizedBox(height: 24),

            AboutSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
