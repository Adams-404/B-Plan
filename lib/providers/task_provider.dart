import 'package:flutter/foundation.dart';
import 'dart:collection'; // For UnmodifiableListView
import 'package:uuid/uuid.dart'; // For generating unique IDs

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  // Use a private list to store tasks
  final List<Task> _tasks = [
    // Sample initial data (optional)
    Task(
      id: const Uuid().v4(),
      title: 'Welcome to B-Plan!',
      subtitle: 'Tap to mark as done, long-press to edit/delete.',
      createdAt: DateTime.now(),
    ),
    Task(
      id: const Uuid().v4(),
      title: 'Add a new task',
      subtitle: 'Use the + button below.',
      createdAt: DateTime.now(),
      priority: TaskPriority.medium,
    ),
    Task(
      id: const Uuid().v4(),
      title: 'Explore other tabs',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
      completedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
     Task(
      id: const Uuid().v4(),
      title: 'Check out Settings',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.low,
    ),
  ];

  // Use Uuid to generate unique IDs
  final _uuid = const Uuid();

  // Provide an unmodifiable view of the tasks to prevent external modification
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  // Get tasks for today (not completed or completed today)
  UnmodifiableListView<Task> get todayTasks {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return UnmodifiableListView(
        _tasks.where((task) => !task.isCompleted || (task.completedAt != null && task.completedAt!.isAfter(startOfToday)))
    );
  }

 // Get only completed tasks
 UnmodifiableListView<Task> get completedTasks {
   return UnmodifiableListView(_tasks.where((task) => task.isCompleted));
 }


  // Add a new task
  void addTask({required String title, String? subtitle, DateTime? dueDate, TaskPriority? priority}) {
    final newTask = Task(
      id: _uuid.v4(),
      title: title,
      subtitle: subtitle,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
    );
    _tasks.add(newTask);
    // Sort tasks after adding (e.g., by creation date)
    _sortTasks();
    notifyListeners(); // Notify listeners about the change
  }

  // Toggle task completion status
  void toggleTaskCompletion(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final bool newCompletionStatus = !task.isCompleted;
      _tasks[taskIndex] = task.copyWith(
        isCompleted: newCompletionStatus,
        completedAt: newCompletionStatus ? DateTime.now() : null,
        forceNullCompletedAt: !newCompletionStatus, // Explicitly set to null if un-completing
      );
      _sortTasks(); // Re-sort if completion status affects order
      notifyListeners();
    }
  }

  // Update an existing task
  void updateTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      _sortTasks();
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  // Internal method to sort tasks (example: by creation date descending)
  // You might want different/more complex sorting later
  void _sortTasks() {
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
     // Example secondary sort: put incomplete items first if creation dates are equal
     _tasks.sort((a, b) {
        int dateComp = b.createdAt.compareTo(a.createdAt);
        if (dateComp == 0) {
            if (!a.isCompleted && b.isCompleted) {
                return -1; // a comes first
            } else if (a.isCompleted && !b.isCompleted) {
                return 1; // b comes first
            }
        }
        return dateComp;
    });
  }

 // --- Filtering/Sorting Logic for AllTasksScreen ---

  // Add state variables for current sort/filter options
  SortOption _currentSortOption = SortOption.dateCreated;
  FilterOption _currentFilterOption = FilterOption.all;

  SortOption get currentSortOption => _currentSortOption;
  FilterOption get currentFilterOption => _currentFilterOption;

  // Method to update sorting
  void setSortOption(SortOption option) {
    _currentSortOption = option;
    notifyListeners(); // Re-filter/sort happens in the getter
  }

  // Method to update filtering
  void setFilterOption(FilterOption option) {
    _currentFilterOption = option;
    notifyListeners(); // Re-filter/sort happens in the getter
  }

  // Getter that applies current filter and sort
  UnmodifiableListView<Task> get filteredAndSortedTasks {
    List<Task> filtered = _tasks;

    // Apply Filter
    switch (_currentFilterOption) {
      case FilterOption.completed:
        filtered = _tasks.where((task) => task.isCompleted).toList();
        break;
      case FilterOption.uncompleted:
        filtered = _tasks.where((task) => !task.isCompleted).toList();
        break;
      case FilterOption.all:
      default:
        // No filter applied
        break;
    }

    // Apply Sort
    filtered.sort((a, b) {
      switch (_currentSortOption) {
        case SortOption.dateCreated:
          // Default sort: newest first, then incomplete first
           int dateComp = b.createdAt.compareTo(a.createdAt);
           if (dateComp == 0) {
               if (!a.isCompleted && b.isCompleted) return -1;
               if (a.isCompleted && !b.isCompleted) return 1;
           }
           return dateComp;
        case SortOption.dueDate:
          // Handle null due dates (e.g., tasks without due dates go last)
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1; // a goes after b
          if (b.dueDate == null) return -1; // b goes after a
          return a.dueDate!.compareTo(b.dueDate!); // Earliest due date first
        case SortOption.priority:
           // Handle null priorities (e.g., no priority goes last)
           int priorityA = a.priority?.index ?? TaskPriority.values.length;
           int priorityB = b.priority?.index ?? TaskPriority.values.length;
           // Compare based on enum index (lower index = higher priority)
           int priorityComp = priorityA.compareTo(priorityB);
           if (priorityComp == 0) {
             // If priorities are same, sort by creation date (newest first)
             return b.createdAt.compareTo(a.createdAt);
           }
           return priorityComp;
      }
    });

    return UnmodifiableListView(filtered);
  }
}

// Enums for sorting and filtering options
enum SortOption { dateCreated, dueDate, priority }
enum FilterOption { all, completed, uncompleted }

