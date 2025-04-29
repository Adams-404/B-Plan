import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../models/task.dart'; // Import Task model

class TodayScreen extends StatelessWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the TaskProvider
    // 'watch' rebuilds the widget when tasks change
    final taskProvider = context.watch<TaskProvider>();

    // Get today's tasks from the provider
    // For Today screen, we might want a specific getter in the provider
    // For now, let's filter here: uncompleted or completed today
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final List<Task> todayTasks = taskProvider.tasks.where((task) {
        final bool isDueToday = task.dueDate != null &&
                                task.dueDate!.year == now.year &&
                                task.dueDate!.month == now.month &&
                                task.dueDate!.day == now.day;
        // Show tasks that are:
        // 1. Not completed AND (created today OR due today OR has no due date)
        // 2. Completed today
        return (!task.isCompleted && (task.createdAt.isAfter(startOfToday) || isDueToday || task.dueDate == null )) ||
               (task.isCompleted && task.completedAt != null && task.completedAt!.isAfter(startOfToday));
      }).toList();

      // Optional: Sort today's tasks (e.g., incomplete first, then by due date/creation)
      todayTasks.sort((a, b) {
         if (a.isCompleted != b.isCompleted) {
           return a.isCompleted ? 1 : -1; // Incomplete tasks first
         }
         // Optional: Sort by due date (earliest first)
         if (a.dueDate != null && b.dueDate != null) {
            int dueDateComp = a.dueDate!.compareTo(b.dueDate!);
            if(dueDateComp != 0) return dueDateComp;
         }
          // Fallback sort by creation date (newest first)
         return b.createdAt.compareTo(a.createdAt);
      });


    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Plan"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.black87), // Make back button dark
      ),
      body: todayTasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks for today!',
                style: TextStyle(fontSize: 18.0, color: Colors.black54, fontStyle: FontStyle.italic),
              ),
            )
          : ListView.builder(
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                final task = todayTasks[index];
                // Use the TaskCard widget
                return TaskCard(task: task);
              },
            ),
    );
  }
}
