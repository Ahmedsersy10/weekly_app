import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_localizations.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_contaner_weekly_of.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/custom_list_view_days.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/statistics_dashboard_widget.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/task_search_widget.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => HomeViewBodyState();
}

class HomeViewBodyState extends State<HomeViewBody> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _dayKeys = {for (int i = 0; i < 6; i++) i: GlobalKey()};

  late TabController _tabController;
  // ignore: unused_field
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.maroon,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.white,
            dividerColor: AppColors.maroon,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            indicatorColor: AppColors.white,
            tabs: [
              Tab(text: AppLocalizations.of(context).tr('app.title')),
              Tab(text: AppLocalizations.of(context).tr('common.Search')),
              Tab(text: AppLocalizations.of(context).tr('app.stats')),
              // Tab(text: 'Stats'),
            ],
          ),
        ),

        // const SizedBox(height: 4),
        // const CustomContainerWeeklyOf(),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Weekly View Tab
              _buildWeeklyView(),
              // Search Tab - Lazy loaded
              _buildLazyWidget(() => const TaskSearchWidget()),

              // Statistics Tab - Lazy loaded
              _buildLazyWidget(() => const StatisticsDashboardWidget()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLazyWidget(Widget Function() builder) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildWeeklyView() {
    return Column(
      children: [
        const SizedBox(height: 4),
        const CustomContainerWeeklyOf(),
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // const SliverToBoxAdapter(child: SizedBox(height: 4)),
              // const SliverToBoxAdapter(child: CustomContainerWeeklyOf()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              CustomListViewDays(dayKeys: _dayKeys),
            ],
          ),
        ),
      ],
    );
  }

  void scrollToDay(int dayIndex) {
    final key = _dayKeys[dayIndex];
    if (key == null) return;
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}
