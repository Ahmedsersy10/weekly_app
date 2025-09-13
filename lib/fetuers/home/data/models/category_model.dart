import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskCategoryModel extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final Color color;
  final bool isDefault;
  final DateTime createdAt;

  const TaskCategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.color,
    this.isDefault = false,
    required this.createdAt,
  });

  TaskCategoryModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    IconData? icon,
    Color? color,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return TaskCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, nameAr, icon, color, isDefault, createdAt];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'colorValue': color.value,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) {
    return TaskCategoryModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['nameAr'],
      icon: IconData(
        json['iconCodePoint'],
        fontFamily: json['iconFontFamily'],
      ),
      color: Color(json['colorValue']),
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Predefined default categories
  static List<TaskCategoryModel> getDefaultCategories() {
    final now = DateTime.now();
    return [
      TaskCategoryModel(
        id: 'work',
        name: 'Work',
        nameAr: 'عمل',
        icon: Icons.work,
        color: const Color(0xFF1976D2), // Blue
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'study',
        name: 'Study',
        nameAr: 'دراسة',
        icon: Icons.school,
        color: const Color(0xFF388E3C), // Green
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'health',
        name: 'Health',
        nameAr: 'صحة',
        icon: Icons.favorite,
        color: const Color(0xFFE53935), // Red
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'personal',
        name: 'Personal',
        nameAr: 'شخصي',
        icon: Icons.person,
        color: const Color(0xFF7B1FA2), // Purple
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'finance',
        name: 'Finance',
        nameAr: 'مالي',
        icon: Icons.attach_money,
        color: const Color(0xFFFF8F00), // Orange
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'home',
        name: 'Home',
        nameAr: 'منزل',
        icon: Icons.home,
        color: const Color(0xFF5D4037), // Brown
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'shopping',
        name: 'Shopping',
        nameAr: 'تسوق',
        icon: Icons.shopping_cart,
        color: const Color(0xFFE91E63), // Pink
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'entertainment',
        name: 'Entertainment',
        nameAr: 'ترفيه',
        icon: Icons.movie,
        color: const Color(0xFF00ACC1), // Cyan
        isDefault: true,
        createdAt: now,
      ),
      TaskCategoryModel(
        id: 'other',
        name: 'Other',
        nameAr: 'أخرى',
        icon: Icons.category,
        color: const Color(0xFF757575), // Grey
        isDefault: true,
        createdAt: now,
      ),
    ];
  }

  // Predefined colors for new categories
  static List<Color> getAvailableColors() {
    return [
      const Color(0xFF1976D2), // Blue
      const Color(0xFF388E3C), // Green
      const Color(0xFFE53935), // Red
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFFF8F00), // Orange
      const Color(0xFF5D4037), // Brown
      const Color(0xFFE91E63), // Pink
      const Color(0xFF00ACC1), // Cyan
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF607D8B), // Blue Grey
      const Color(0xFFFFC107), // Amber
      const Color(0xFF795548), // Brown
      const Color(0xFF009688), // Teal
    ];
  }

  // Predefined icons for new categories
  static List<IconData> getAvailableIcons() {
    return [
      Icons.work,
      Icons.school,
      Icons.favorite,
      Icons.person,
      Icons.attach_money,
      Icons.home,
      Icons.shopping_cart,
      Icons.movie,
      Icons.category,
      Icons.fitness_center,
      Icons.restaurant,
      Icons.directions_car,
      Icons.flight,
      Icons.music_note,
      Icons.camera_alt,
      Icons.book,
      Icons.computer,
      Icons.phone,
      Icons.email,
      Icons.event,
      Icons.location_on,
      Icons.star,
      Icons.lightbulb,
      Icons.palette,
      Icons.sports_soccer,
    ];
  }
}
