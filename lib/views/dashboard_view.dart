import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/home_view_body.dart';
import 'package:weekly_dash_board/util/dashboard_controller.dart';
import 'package:weekly_dash_board/util/drawer_page.dart';
import 'package:weekly_dash_board/util/size_config.dart';
import 'package:weekly_dash_board/views/widgets/adaptive_layout.dart';
import 'package:weekly_dash_board/views/widgets/custom_drawer.dart' show CustomDrawer;
import 'package:weekly_dash_board/views/widgets/dashboard_desktop_layout.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_layout_mobile.dart';
import 'package:weekly_dash_board/views/widgets/dashbord_tablet_layout.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<HomeViewBodyState> _bodyKey = GlobalKey<HomeViewBodyState>();
  final DashboardController _controller = DashboardController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDrawerItemSelected(int index, DrawerPage page) {
    _controller.changePage(page);

    if (MediaQuery.of(context).size.width < SizeConfig.tablet) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width >= SizeConfig.tablet
            ? AppBar(
                title: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return Text(
                      _getPageTitle(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                actions: [
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) {
                      return Row(mainAxisSize: MainAxisSize.min, children: _buildAppBarActions());
                    },
                  ),
                ],
              )
            : null,

        drawer: MediaQuery.of(context).size.width < SizeConfig.tablet
            ? CustomDrawer(onItemSelected: _onDrawerItemSelected)
            : null,
        backgroundColor: AppColors.background,
        body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return AdaptiveLayout(
              mobileLayout: (context) => DashboardMobileLayout(
                currentPage: _controller.currentPage,
                onItemSelected: _onDrawerItemSelected,
              ),
              tabletLayout: (context) => DashboardTabletLayout(
                currentPage: _controller.currentPage,
                onItemSelected: _onDrawerItemSelected,
              ),
              desktopLayout: (context) => DashboardDesktopLayout(
                currentPage: _controller.currentPage,
                onItemSelected: _onDrawerItemSelected,
              ),
            );
          },
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_controller.currentPage) {
      case DrawerPage.weekly:
        return AppLocalizations.of(context).tr('app.title');
      case DrawerPage.search:
        return AppLocalizations.of(context).tr('common.Search');
      case DrawerPage.stats:
        return AppLocalizations.of(context).tr('app.stats');
      case DrawerPage.more:
        return AppLocalizations.of(context).tr('app.more');
      case DrawerPage.settings:
        return AppLocalizations.of(context).tr('app.settings');
    }
  }

  List<Widget> _buildAppBarActions() {
    if (_controller.currentPage == DrawerPage.weekly) {
      return [
        IconButton(onPressed: _openCalendar, icon: const Icon(Icons.calendar_month_outlined)),
        IconButton(
          onPressed: _showClearAllTasksDialog,
          icon: const Icon(Icons.clear_all),
          tooltip: AppLocalizations.of(context).tr('settings.clearAllTasks'),
        ),
      ];
    } else if (_controller.currentPage == DrawerPage.search) {
      return [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))];
    }
    return [];
  }

  void _openCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime focusedDay = DateTime.now();
        DateTime? selectedDay = focusedDay;
        return AlertDialog(
          backgroundColor: AppColors.surface,
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
                    defaultTextStyle: TextStyle(color: AppColors.textPrimary), // لون الأرقام
                    weekNumberTextStyle: TextStyle(color: AppColors.textPrimary),
                    todayTextStyle: TextStyle(color: AppColors.textPrimary),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: AppColors.textPrimary), // لون الشهر
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppColors.textPrimary, // لون السهم الأيسر
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppColors.textPrimary, // لون السهم الأيمن
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
                style: const TextStyle(color: AppColors.primary),
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
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
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
          backgroundColor: AppColors.surface,
          title: Text(AppLocalizations.of(context).tr('settings.clearAllTasksTitle')),
          content: Text(AppLocalizations.of(context).tr('settings.clearAllTasksConfirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).tr('settings.cancel'),
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<WeeklyCubit>().clearAllTasks();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
              child: Text(AppLocalizations.of(context).tr('common.confirm')),
            ),
          ],
        );
      },
    );
  }

  int? _mapDateToAppDayIndex(DateTime date) {
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
