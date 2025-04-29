import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../models/task.dart'; // Import Task model

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the TaskProvider - 'watch' rebuilds on changes
    final taskProvider = context.watch<TaskProvider>();

    // Get the filtered and sorted list directly from the provider
    final List<Task> tasks = taskProvider.filteredAndSortedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: [
          // Filter Button
          PopupMenuButton<FilterOption>(
            tooltip: 'Filter Tasks',
            onSelected: (FilterOption result) {
              // Don't need listen: false here, as we're just calling a method
              context.read<TaskProvider>().setFilterOption(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterOption>>[
              const PopupMenuItem<FilterOption>(value: FilterOption.all,
                child: Text('All Tasks'),
              ),
              const PopupMenuItem<FilterOption>(value: FilterOption.uncompleted,
                child: Text('Uncompleted'),
              ),
              const PopupMenuItem<FilterOption>(value: FilterOption.completed,
                child: Text('Completed'),
              ),
            ],
            // Show current filter as icon hint
            icon: Badge(
              label: Text(taskProvider.currentFilterOption.name.substring(0, 1).toUpperCase()),
              isLabelVisible: taskProvider.currentFilterOption != FilterOption.all,
              child: const Icon(Icons.filter_list),),
          ),
          // Sort Button
          PopupMenuButton<SortOption>(
            tooltip: 'Sort Tasks',
            onSelected: (SortOption result) {
              context.read<TaskProvider>().setSortOption(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.dateCreated,
                child: Text('Sort by Date Created'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.dueDate,
                child: Text('Sort by Due Date'),
              ),
               const PopupMenuItem<SortOption>(
                value: SortOption.priority,
                child: Text('Sort by Priority'),
              ),
            ], // Show current sort as icon hint (optional)
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks found. Add one using the + button!',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                // Use the TaskCard widget
                return TaskCard(task: task);
              },
            ),
    );
  }
}
