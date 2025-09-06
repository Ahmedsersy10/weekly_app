import '../../fetuers/home/data/models/task_model.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  List<TaskModel> searchTasks(String query, List<TaskModel> tasks) {
    if (query.trim().isEmpty) return tasks;

    final lowercaseQuery = query.toLowerCase();

    // Use more efficient search with early termination
    final results = <TaskModel>[];
    for (final task in tasks) {
      if (task.title.toLowerCase().contains(lowercaseQuery)) {
        results.add(task);
        continue;
      }

      if (task.description?.toLowerCase().contains(lowercaseQuery) == true) {
        results.add(task);
        continue;
      }

      if (task.category.name.toLowerCase().contains(lowercaseQuery)) {
        results.add(task);
        continue;
      }

      // Check tags more efficiently
      bool tagMatch = false;
      for (final tag in task.tags) {
        if (tag.toLowerCase().contains(lowercaseQuery)) {
          tagMatch = true;
          break;
        }
      }
      if (tagMatch) {
        results.add(task);
        continue;
      }

      if (task.notes?.toLowerCase().contains(lowercaseQuery) == true) {
        results.add(task);
      }
    }

    return results;
  }

  List<TaskModel> searchTasksByCategory(
    String category,
    List<TaskModel> tasks,
  ) {
    if (category.trim().isEmpty) return tasks;

    return tasks.where((task) {
      return task.category.name.toLowerCase().contains(category.toLowerCase());
    }).toList();
  }

  List<TaskModel> searchTasksByPriority(
    TaskPriority priority,
    List<TaskModel> tasks,
  ) {
    return tasks.where((task) => task.priority == priority).toList();
  }

  List<TaskModel> searchTasksByDateRange(
    DateTime startDate,
    DateTime endDate,
    List<TaskModel> tasks,
  ) {
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ) &&
          task.dueDate!.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  List<TaskModel> searchTasksByTags(List<String> tags, List<TaskModel> tasks) {
    if (tags.isEmpty) return tasks;

    return tasks.where((task) {
      return tags.any(
        (tag) => task.tags.any(
          (taskTag) => taskTag.toLowerCase().contains(tag.toLowerCase()),
        ),
      );
    }).toList();
  }

  List<TaskModel> searchOverdueTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isOverdue).toList();
  }

  List<TaskModel> searchDueTodayTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isDueToday).toList();
  }

  List<TaskModel> searchDueSoonTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isDueSoon).toList();
  }

  List<TaskModel> searchCompletedTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isCompleted).toList();
  }

  List<TaskModel> searchIncompleteTasks(List<TaskModel> tasks) {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<TaskModel> searchImportantTasks(List<TaskModel> tasks) {
    return tasks.where((task) => task.isImportant).toList();
  }

  List<TaskModel> searchTasksByDay(int dayOfWeek, List<TaskModel> tasks) {
    return tasks.where((task) => task.dayOfWeek == dayOfWeek).toList();
  }

  List<TaskModel> searchTasksByEstimatedTime(
    int minMinutes,
    int maxMinutes,
    List<TaskModel> tasks,
  ) {
    return tasks.where((task) {
      return task.estimatedMinutes >= minMinutes &&
          task.estimatedMinutes <= maxMinutes;
    }).toList();
  }

  // Advanced search with multiple criteria
  List<TaskModel> advancedSearch({
    String? query,
    TaskCategory? category,
    TaskPriority? priority,
    bool? isCompleted,
    bool? isImportant,
    int? dayOfWeek,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    int? minEstimatedMinutes,
    int? maxEstimatedMinutes,
    List<TaskModel>? tasks,
  }) {
    if (tasks == null) return [];

    List<TaskModel> results = List.from(tasks);

    // Apply text search if query is provided
    if (query != null && query.trim().isNotEmpty) {
      results = searchTasks(query, results);
    }

    // Apply category filter
    if (category != null) {
      results = results.where((task) => task.category == category).toList();
    }

    // Apply priority filter
    if (priority != null) {
      results = results.where((task) => task.priority == priority).toList();
    }

    // Apply completion filter
    if (isCompleted != null) {
      results = results
          .where((task) => task.isCompleted == isCompleted)
          .toList();
    }

    // Apply importance filter
    if (isImportant != null) {
      results = results
          .where((task) => task.isImportant == isImportant)
          .toList();
    }

    // Apply day filter
    if (dayOfWeek != null) {
      results = results.where((task) => task.dayOfWeek == dayOfWeek).toList();
    }

    // Apply date range filter
    if (startDate != null && endDate != null) {
      results = searchTasksByDateRange(startDate, endDate, results);
    }

    // Apply tags filter
    if (tags != null && tags.isNotEmpty) {
      results = searchTasksByTags(tags, results);
    }

    // Apply estimated time filter
    if (minEstimatedMinutes != null || maxEstimatedMinutes != null) {
      final min = minEstimatedMinutes ?? 0;
      final max = maxEstimatedMinutes ?? 999999;
      results = searchTasksByEstimatedTime(min, max, results);
    }

    return results;
  }

  // Get search suggestions based on task titles and categories
  List<String> getSearchSuggestions(
    List<TaskModel> tasks,
    String partialQuery,
  ) {
    if (partialQuery.trim().isEmpty) return [];

    final suggestions = <String>{};

    for (final task in tasks) {
      if (task.title.toLowerCase().contains(partialQuery.toLowerCase())) {
        suggestions.add(task.title);
      }

      if (task.category.name.toLowerCase().contains(
        partialQuery.toLowerCase(),
      )) {
        suggestions.add(task.category.name);
      }

      for (final tag in task.tags) {
        if (tag.toLowerCase().contains(partialQuery.toLowerCase())) {
          suggestions.add(tag);
        }
      }
    }

    return suggestions.take(10).toList();
  }

  // Get trending search terms based on task frequency
  List<String> getTrendingSearchTerms(List<TaskModel> tasks) {
    final categoryCount = <String, int>{};
    final tagCount = <String, int>{};

    for (final task in tasks) {
      categoryCount[task.category.name] =
          (categoryCount[task.category.name] ?? 0) + 1;

      for (final tag in task.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }

    final trending = <String>[];

    // Add top categories
    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedCategories.take(5)) {
      trending.add(entry.key);
    }

    // Add top tags
    final sortedTags = tagCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedTags.take(5)) {
      trending.add(entry.key);
    }

    return trending;
  }

  // Fuzzy search implementation
  List<TaskModel> fuzzySearch(String query, List<TaskModel> tasks) {
    if (query.trim().isEmpty) return tasks;

    final results = <TaskModel>[];
    final queryWords = query.toLowerCase().split(' ');

    for (final task in tasks) {
      double score = 0.0;
      final taskText =
          '${task.title} ${task.description ?? ''} ${task.category.name} ${task.tags.join(' ')} ${task.notes ?? ''}'
              .toLowerCase();

      for (final word in queryWords) {
        if (taskText.contains(word)) {
          score += 1.0;
        }

        // Partial word matching
        if (word.length > 2) {
          for (int i = 0; i <= taskText.length - word.length; i++) {
            final substring = taskText.substring(i, i + word.length);
            if (_calculateSimilarity(word, substring) > 0.8) {
              score += 0.5;
              break;
            }
          }
        }
      }

      if (score > 0) {
        results.add(task);
      }
    }

    // Sort by relevance score
    results.sort((a, b) {
      final scoreA = _calculateRelevanceScore(query, a);
      final scoreB = _calculateRelevanceScore(query, b);
      return scoreB.compareTo(scoreA);
    });

    return results;
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;

    if (longer.isEmpty) return 1.0;

    return (longer.length - _editDistance(longer, shorter)) / longer.length;
  }

  int _editDistance(String s1, String s2) {
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          matrix[i][j] = matrix[i - 1][j - 1];
        } else {
          matrix[i][j] =
              1 +
              [
                matrix[i - 1][j],
                matrix[i][j - 1],
                matrix[i - 1][j - 1],
              ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return matrix[s1.length][s2.length];
  }

  double _calculateRelevanceScore(String query, TaskModel task) {
    double score = 0.0;
    final queryLower = query.toLowerCase();

    // Title match (highest weight)
    if (task.title.toLowerCase().contains(queryLower)) {
      score += 10.0;
    }

    // Description match
    if (task.description?.toLowerCase().contains(queryLower) ?? false) {
      score += 5.0;
    }

    // Category match
    if (task.category.name.toLowerCase().contains(queryLower)) {
      score += 3.0;
    }

    // Tags match
    for (final tag in task.tags) {
      if (tag.toLowerCase().contains(queryLower)) {
        score += 2.0;
      }
    }

    // Notes match
    if (task.notes?.toLowerCase().contains(queryLower) ?? false) {
      score += 1.0;
    }

    return score;
  }
}
