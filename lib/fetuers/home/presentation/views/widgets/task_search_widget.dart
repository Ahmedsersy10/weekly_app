import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weekly_dash_board/core/util/app_color.dart';
import 'package:weekly_dash_board/core/util/app_style.dart';
import 'package:weekly_dash_board/core/services/search_service.dart';
import 'package:weekly_dash_board/core/services/performance_service.dart';
import 'package:weekly_dash_board/fetuers/home/data/models/task_model.dart';
import 'package:weekly_dash_board/fetuers/home/presentation/view_model/weekly_cubit.dart';

import 'package:weekly_dash_board/fetuers/home/presentation/views/widgets/enhanced_task_item.dart';

class TaskSearchWidget extends StatefulWidget {
  const TaskSearchWidget({super.key});

  @override
  State<TaskSearchWidget> createState() => _TaskSearchWidgetState();
}

class _TaskSearchWidgetState extends State<TaskSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  final PerformanceService _performanceService = PerformanceService();

  String _searchQuery = '';
  List<TaskModel> _searchResults = [];
  List<TaskModel> _allTasks = [];
  bool _isSearching = false;

  // Filter states
  TaskCategory? _selectedCategory;
  TaskPriority? _selectedPriority;
  bool? _selectedCompletionStatus;
  bool? _selectedImportanceStatus;
  int? _selectedDay;

  // Advanced search options
  bool _showAdvancedFilters = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedTags = [];
  int? _minEstimatedMinutes;
  int? _maxEstimatedMinutes;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _performanceService.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });

    // Use debounced search to improve performance
    _performanceService.debounceSearch(() {
      if (mounted) {
        _performSearch();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _searchResults = [];
    });
  }

  List<TaskModel> get _filteredTasks {
    if (_searchQuery.trim().isEmpty) {
      return [];
    }
    return _searchResults;
  }

  void _performSearch() {
    if (_searchQuery.trim().isEmpty &&
        _selectedCategory == null &&
        _selectedPriority == null &&
        _selectedCompletionStatus == null &&
        _selectedImportanceStatus == null &&
        _selectedDay == null &&
        _startDate == null &&
        _endDate == null &&
        _selectedTags.isEmpty &&
        _minEstimatedMinutes == null &&
        _maxEstimatedMinutes == null) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Use microtask to avoid blocking the main thread
    Future.microtask(() {
      if (!mounted) return;

      // Perform advanced search
      final results = _searchService.advancedSearch(
        query: _searchQuery.trim().isEmpty ? null : _searchQuery,
        category: _selectedCategory,
        priority: _selectedPriority,
        isCompleted: _selectedCompletionStatus,
        isImportant: _selectedImportanceStatus,
        dayOfWeek: _selectedDay,
        startDate: _startDate,
        endDate: _endDate,
        tags: _selectedTags.isEmpty ? null : _selectedTags,
        minEstimatedMinutes: _minEstimatedMinutes,
        maxEstimatedMinutes: _maxEstimatedMinutes,
        tasks: _allTasks,
      );

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeeklyCubit, WeeklyState>(
      builder: (context, state) {
        if (state is! WeeklySuccess) {
          return const SizedBox.shrink();
        }

        // Update all tasks from the cubit state
        _allTasks = state.weeklyState.tasks;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.warm,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search tasks',
                  prefixIcon: const Icon(Icons.search, color: AppColors.black),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.black),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.maroon,
                      width: 2,
                    ),
                  ),
                ),
              ),

              if (_searchController.text.isNotEmpty) ...[
                const SizedBox(height: 16),

                // Search Results
                Text(
                  'Search Results (${_filteredTasks.length})',
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: AppColors.black),
                ),
                const SizedBox(height: 8),

                if (_filteredTasks.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_off,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'No tasks found matching "${_searchController.text}"',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];
                        return _buildSearchResultItem(context, task);
                      },
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _buildSearchInterface() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                focusColor: Colors.black,
                hintText: 'Search tasks, categories, tags...',
                prefixIcon: const Icon(Icons.search, color: AppColors.maroon),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.maroon),
                        onPressed: () {
                          _searchController.clear();
                          _clearAllFilters();
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          _showAdvancedFilters
                              ? Icons.filter_list
                              : Icons.filter_list_outlined,
                          color: AppColors.maroon,
                        ),
                        onPressed: () {
                          setState(() {
                            _showAdvancedFilters = !_showAdvancedFilters;
                          });
                        },
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),

          // Advanced filters
          // if (_showAdvancedFilters) _buildAdvancedFilters(),

          // Search results
          _buildSearchResults(),
        ],
      ),
    );
  }

  // Widget _buildAdvancedFilters() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Advanced Filters',
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
  //         ),
  //         const SizedBox(height: 16),

  //         // Category and Priority filters
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildDropdownFilter<TaskCategory>(
  //                 'Category',
  //                 _selectedCategory,
  //                 TaskCategory.values,
  //                 (value) {
  //                   setState(() {
  //                     _selectedCategory = value;
  //                   });
  //                   _performSearch();
  //                 },
  //                 (category) => category.name.toUpperCase(),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildDropdownFilter<TaskPriority>(
  //                 'Priority',
  //                 _selectedPriority,
  //                 TaskPriority.values,
  //                 (value) {
  //                   setState(() {
  //                     _selectedPriority = value;
  //                   });
  //                   _performSearch();
  //                 },
  //                 (priority) => priority.name.toUpperCase(),
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 16),

  //         // Completion and Importance filters
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildDropdownFilter<bool?>(
  //                 'Status',
  //                 _selectedCompletionStatus,
  //                 [null, true, false],
  //                 (value) {
  //                   setState(() {
  //                     _selectedCompletionStatus = value;
  //                   });
  //                   _performSearch();
  //                 },
  //                 (value) {
  //                   if (value == null) return 'All';
  //                   return value ? 'Completed' : 'Pending';
  //                 },
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildDropdownFilter<bool?>(
  //                 'Importance',
  //                 _selectedImportanceStatus,
  //                 [null, true, false],
  //                 (value) {
  //                   setState(() {
  //                     _selectedImportanceStatus = value;
  //                   });
  //                   _performSearch();
  //                 },
  //                 (value) {
  //                   if (value == null) return 'All';
  //                   return value ? 'Important' : 'Regular';
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 16),

  //         // Day filter
  //         _buildDropdownFilter<int?>(
  //           'Day of Week',
  //           _selectedDay,
  //           [null, 0, 1, 2, 3, 4, 5],
  //           (value) {
  //             setState(() {
  //               _selectedDay = value;
  //             });
  //             _performSearch();
  //           },
  //           (value) {
  //             if (value == null) return 'All Days';
  //             final days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  //             return days[value];
  //           },
  //         ),

  //         const SizedBox(height: 16),

  //         // Date range filters
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildDateFilter('Start Date', _startDate, (date) {
  //                 setState(() {
  //                   _startDate = date;
  //                 });
  //                 _performSearch();
  //               }),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildDateFilter('End Date', _endDate, (date) {
  //                 setState(() {
  //                   _endDate = date;
  //                 });
  //                 _performSearch();
  //               }),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 16),

  //         // Estimated time filters
  //         Row(
  //           children: [
  //             Expanded(
  //               child: _buildNumberFilter('Min Time (min)', _minEstimatedMinutes, (value) {
  //                 setState(() {
  //                   _minEstimatedMinutes = value;
  //                 });
  //                 _performSearch();
  //               }),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: _buildNumberFilter('Max Time (min)', _maxEstimatedMinutes, (value) {
  //                 setState(() {
  //                   _maxEstimatedMinutes = value;
  //                 });
  //                 _performSearch();
  //               }),
  //             ),
  //           ],
  //         ),

  //         const SizedBox(height: 16),

  //         // Clear filters button
  //         SizedBox(
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             onPressed: _clearAllFilters,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.maroon,
  //               foregroundColor: AppColors.white,
  //               padding: const EdgeInsets.symmetric(vertical: 12),
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //             ),
  //             child: const Text('Clear All Filters'),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDropdownFilter<T>(
  //   String label,
  //   T? value,
  //   List<T> options,
  //   ValueChanged<T?> onChanged,
  //   String Function(T) displayText,
  // ) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.black),
  //       ),
  //       const SizedBox(height: 4),
  //       DropdownButtonFormField<T>(
  //         value: value,
  //         decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //         ),
  //         items: options.map((option) {
  //           return DropdownMenuItem(value: option, child: Text(displayText(option)));
  //         }).toList(),
  //         onChanged: onChanged,
  //         isExpanded: true,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDateFilter(String label, DateTime? value, ValueChanged<DateTime?> onChanged) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.black),
  //       ),
  //       const SizedBox(height: 4),
  //       InkWell(
  //         onTap: () async {
  //           final date = await showDatePicker(
  //             context: context,
  //             initialDate: value ?? DateTime.now(),
  //             firstDate: DateTime(2020),
  //             lastDate: DateTime(2030),
  //           );
  //           if (date != null) {
  //             onChanged(date);
  //           }
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),
  //             borderRadius: BorderRadius.circular(4),
  //           ),
  //           child: Row(
  //             children: [
  //               Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
  //               const SizedBox(width: 8),
  //               Text(
  //                 value?.toString().split(' ')[0] ?? 'Select Date',
  //                 style: TextStyle(color: value != null ? AppColors.black : Colors.grey[600]),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildNumberFilter(String label, int? value, ValueChanged<int?> onChanged) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.black),
  //       ),
  //       const SizedBox(height: 4),
  //       TextField(
  //         decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //         ),
  //         keyboardType: TextInputType.number,
  //         onChanged: (text) {
  //           if (text.isEmpty) {
  //             onChanged(null);
  //           } else {
  //             final number = int.tryParse(text);
  //             if (number != null) {
  //               onChanged(number);
  //             }
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty && _searchQuery.trim().isNotEmpty) {
      return _buildNoResults();
    }

    if (_searchResults.isEmpty) {
      return _buildSearchSuggestions();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${_searchResults.length} task${_searchResults.length == 1 ? '' : 's'} found',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),

        // Results list
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: _searchResults.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final task = _searchResults[index];
            return EnhancedTaskItem(
              task: task,
              onEdit: () => _editTask(task),
              onDelete: () => _deleteTask(task),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = _searchService.getSearchSuggestions(
      _allTasks,
      _searchQuery,
    );
    final trending = _searchService.getTrendingSearchTerms(_allTasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (suggestions.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Search Suggestions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    _searchController.text = suggestion;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.maroon.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.maroon.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        color: AppColors.maroon,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],

        if (trending.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Trending',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trending.map((term) {
                return InkWell(
                  onTap: () {
                    _searchController.text = term;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      term,
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedPriority = null;
      _selectedCompletionStatus = null;
      _selectedImportanceStatus = null;
      _selectedDay = null;
      _startDate = null;
      _endDate = null;
      _selectedTags.clear();
      _minEstimatedMinutes = null;
      _maxEstimatedMinutes = null;
    });
    _performSearch();
  }

  void _editTask(TaskModel task) {
    print('Edit task: ${task.title}');
  }

  void _deleteTask(TaskModel task) {
    print('Delete task: ${task.title}');
  }

  Widget _buildSearchResultItem(BuildContext context, TaskModel task) {
    return EnhancedTaskItem(
      task: task,
      onEdit: () => _editTask(task),
      onDelete: () => _deleteTask(task),
    );
  }
}
