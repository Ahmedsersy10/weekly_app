// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/home_view_body.dart';
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/adaptive_layout.dart';
import 'package:weekly_dash_board/views/widgets/custom_drawer.dart' show CustomDrawer;
import 'package:weekly_dash_board/views/widgets/dashboard_desktop_layout.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_layout_mobile.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_tablet_layout.dart';

// Project imports:

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<HomeViewBodyState> _bodyKey = GlobalKey<HomeViewBodyState>();

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width >= SizeConfig.tablet
            ? AppBar(
                title: Text(
                  AppLocalizations.of(context).tr('app.title'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.white,
                actions: [
                  IconButton(
                    onPressed: _openCalendar,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                  IconButton(
                    onPressed: _showClearAllTasksDialog,
                    icon: const Icon(Icons.clear_all),
                    tooltip: AppLocalizations.of(context).tr('settings.clearAllTasks'),
                  ),
                ],
              )
            : null,
        drawer: MediaQuery.of(context).size.width < SizeConfig.tablet ? const CustomDrawer() : null,
        backgroundColor: const Color(0xffE5E5E5),
        body: AdaptiveLayout(
          mobileLayout: (context) => const DashbordLayoutMobile(),
          tabletLayout: (context) => const DashbordTabletLayout(),
          desktopLayout: (context) => const DashboardDesktopLayout(),
        ),
      ),
    );
  }

  void _openCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime focusedDay = DateTime.now();
        DateTime? selectedDay = focusedDay;
        return AlertDialog(
          backgroundColor: AppColors.white,
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 400, // ارتفاع مناسب للكاليندر
                child: TableCalendar(
                  firstDay: DateTime.utc(2015, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: focusedDay,
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: AppColors.black), // لون الأرقام
                    weekNumberTextStyle: TextStyle(color: AppColors.black),
                    todayTextStyle: TextStyle(color: AppColors.black),
                    todayDecoration: BoxDecoration(color: AppColors.maroon, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.maroon,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: AppColors.black), // لون الشهر
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.black, // لون السهم الأيسر
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.black, // لون السهم الأيمن
                    ),
                  ),
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  onDaySelected: (sel, foc) {
                    setState(() {
                      selectedDay = sel;
                      focusedDay = foc;
                    });
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).tr('settings.cancel'),
                style: const TextStyle(color: AppColors.maroon),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDay != null) {
                  final dayIndex = _mapDateToAppDayIndex(selectedDay!);
                  if (dayIndex != null) {
                    _bodyKey.currentState?.scrollToDay(dayIndex);
                  }
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppLocalizations.of(context).tr('common.go')),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllTasksDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(AppLocalizations.of(context).tr('settings.clearAllTasksTitle')),
          content: Text(AppLocalizations.of(context).tr('settings.clearAllTasksConfirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).tr('settings.cancel'),
                style: const TextStyle(color: AppColors.maroon),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<WeeklyCubit>().clearAllTasks();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.maroon,
                foregroundColor: AppColors.white,
              ),
              child: Text(AppLocalizations.of(context).tr('common.confirm')),
            ),
          ],
        );
      },
    );
  }

  int? _mapDateToAppDayIndex(DateTime date) {
    // App indices: 0=Saturday ... 5=Thursday, Friday off
    // Dart weekday: Monday=1 ... Sunday=7
    // Map: Saturday(6)->0, Sunday(7)->1, Monday(1)->2, Tuesday(2)->3, Wednesday(3)->4, Thursday(4)->5, Friday(5)->off
    final weekday = date.weekday; // 1..7
    switch (weekday) {
      case DateTime.saturday: // 6
        return 0;
      case DateTime.sunday: // 7
        return 1;
      case DateTime.monday: // 1
        return 2;
      case DateTime.tuesday: // 2
        return 3;
      case DateTime.wednesday: // 3
        return 4;
      case DateTime.thursday: // 4
        return 5;
      case DateTime.friday: // 5
        return null; // day off
    }
    return null;
  }
}
