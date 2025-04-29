import 'package:flutter/foundation.dart' show immutable;

// Using an enum for optional priority
enum TaskPriority { low, medium, high }

@immutable // Makes the class immutable, good practice for models
class Task {
  final String id;
  final String title;
  final String? subtitle; // Optional subtitle/description
  final DateTime createdAt;
  final DateTime? dueDate; // Optional due date
  final bool isCompleted;
  final DateTime? completedAt; // When the task was completed
  final TaskPriority? priority; // Optional priority

  const Task({
    required this.id,
    required this.title,
    this.subtitle,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false, // Defaults to not completed
    this.completedAt,
    this.priority,
  });

  // Helper method to create a copy with updated values
  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
    TaskPriority? priority,
    bool forceNullSubtitle = false, // To explicitly set subtitle to null
    bool forceNullDueDate = false, // To explicitly set dueDate to null
    bool forceNullCompletedAt = false, // To explicitly set completedAt to null
    bool forceNullPriority = false, // To explicitly set priority to null
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      // Handle null assignment explicitly
      subtitle: forceNullSubtitle ? null : (subtitle ?? this.subtitle),
      createdAt: createdAt ?? this.createdAt,
      dueDate: forceNullDueDate ? null : (dueDate ?? this.dueDate),
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: forceNullCompletedAt ? null : (completedAt ?? this.completedAt),
      priority: forceNullPriority ? null : (priority ?? this.priority),
    );
  }

 // Optional: Override == and hashCode for comparisons if needed, especially if using Sets or Maps
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          createdAt == other.createdAt &&
          dueDate == other.dueDate &&
          isCompleted == other.isCompleted &&
          completedAt == other.completedAt &&
          priority == other.priority;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      createdAt.hashCode ^
      dueDate.hashCode ^
      isCompleted.hashCode ^
      completedAt.hashCode ^
      priority.hashCode;

 // Optional: toString for easy debugging
 @override
 String toString() {
   return 'Task{id: $id, title: $title, subtitle: $subtitle, createdAt: $createdAt, dueDate: $dueDate, isCompleted: $isCompleted, completedAt: $completedAt, priority: $priority}';
 }
}
