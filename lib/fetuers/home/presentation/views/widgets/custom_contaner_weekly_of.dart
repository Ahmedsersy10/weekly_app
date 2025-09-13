import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_text_weekly_of.dart';

class CustomContainerWeeklyOf extends StatelessWidget {
  const CustomContainerWeeklyOf({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: _buildContainerDecoration(),
          child: state is WeeklySuccess
              ? _buildSuccessContent(context, state.weeklyState)
              : _buildZeroStateContent(context),
        );
      },
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
      color: AppColors.surface,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 4),
          spreadRadius: 2,
        ),
      ],
    );
  }

  Widget _buildSuccessContent(BuildContext context, dynamic weeklyState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFirstRow(context, weeklyState),
        const SizedBox(height: 12),
        _buildSecondRow(context, weeklyState),
      ],
    );
  }

  Widget _buildFirstRow(BuildContext context, dynamic weeklyState) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            AppLocalizations.of(context).trWithParams('settings.weekOf', {
              'weekNumber': weeklyState.weekNumber.toString(),
            }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            '${AppLocalizations.of(context).tr('common.done')} : ${weeklyState.completedTasks} / ${weeklyState.totalTasks}',
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, dynamic weeklyState) {
    final percentage = weeklyState.completionPercentage;
    final percentageLabel = _getPerformanceLabel(context, percentage);

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            AppLocalizations.of(context).trWithParams(
              'settings.completionPercentage',
              {'percentage': percentage.toStringAsFixed(0)},
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            percentageLabel,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 18.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title, {
    EdgeInsets? padding,
  }) {
    return Container(
      padding:
          padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: _buildCardDecoration(),
      child: Center(child: CustomTextWeeklyOf(title: title)),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }

  Widget _buildZeroStateContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextWeeklyOf(
          title: AppLocalizations.of(context).trWithParams(
            'settings.weeklyOf',
            {
              'weekNumber': AppLocalizations.of(
                context,
              ).tr('settings.zeroWeek'),
            },
          ),
        ),
        const SizedBox(height: 12),
        CustomTextWeeklyOf(
          title: AppLocalizations.of(context).tr('settings.zeroProgress'),
        ),
        const SizedBox(height: 12),
        CustomTextWeeklyOf(
          title: AppLocalizations.of(context).tr('settings.zeroPercentage'),
        ),
      ],
    );
  }

  String _getPerformanceLabel(BuildContext context, double percentage) {
    if (percentage >= 90) {
      return AppLocalizations.of(context).tr('settings.excellent');
    } else if (percentage >= 70) {
      return AppLocalizations.of(context).tr('settings.good');
    } else if (percentage >= 50) {
      return AppLocalizations.of(context).tr('settings.average');
    } else {
      return AppLocalizations.of(context).tr('common.needs');
    }
  }
}
