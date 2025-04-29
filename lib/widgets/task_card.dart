import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color? completedColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final Color? defaultColor = Theme.of(context).cardColor; // Use theme's card color

    return Card(
      elevation: 2.0, // Subtle shadow
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: task.isCompleted ? completedColor : defaultColor, // Visual feedback for completion
      child: InkWell( // Makes the card tappable
        onTap: () {
          taskProvider.toggleTaskCompletion(task.id);
          // Optional: Add subtle animation or feedback on tap
        },
        onLongPress: () {
          // Show options dialog (Edit/Delete)
          _showOptionsDialog(context, taskProvider, task);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Checkbox/Icon for completion status
              Icon(
                task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task.isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
                size: 24.0,
              ),
              const SizedBox(width: 12.0),
              // Task Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        // Apply strike-through if completed
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey[600] : null, // Dim completed text
                      ),
                    ),
                    if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        task.subtitle!,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[600],
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        maxLines: 2, // Limit subtitle lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                     if (task.dueDate != null) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        'Due: ${DateFormat.yMd().add_jm().format(task.dueDate!)}', // Format date nicely
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _getDueDateColor(context, task), // Color based on due date proximity
                           decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
             // Optional: Priority Indicator
             if (task.priority != null) ...[
                const SizedBox(width: 8.0),
                _buildPriorityIndicator(task.priority!),
             ]
            ],
          ),
        ),
      ),
    );
  }

  // Helper to show Edit/Delete options
  void _showOptionsDialog(BuildContext context, TaskProvider taskProvider, Task task) {
    showModalBottomSheet( // Using bottom sheet for options
      context: context,
      builder: (BuildContext ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Task'),
              onTap: () {
                Navigator.pop(ctx); // Close the bottom sheet
                // TODO: Navigate to an Edit Task screen/dialog
                // For now, just print
                print("Edit task: ${task.id}");
                // You would typically pass the task to the edit screen
                // _showEditTaskDialog(context, taskProvider, task);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Delete Task', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                 Navigator.pop(ctx); // Close the bottom sheet
                 _confirmDelete(context, taskProvider, task); // Show confirmation dialog
              },
            ),
             ListTile( // Optional: Cancel button
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        );
      },
    );
  }

 // Confirmation dialog for deletion
  void _confirmDelete(BuildContext context, TaskProvider taskProvider, Task task) {
     showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
            ),
            TextButton(
               style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                taskProvider.deleteTask(task.id);
                Navigator.of(ctx).pop(); // Close the dialog
                 // Optional: Show a confirmation SnackBar
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task "${task.title}" deleted.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
              },
            ),
          ],
        );
      },
    );
  }

  // Helper to determine due date text color
  Color _getDueDateColor(BuildContext context, Task task) {
    if (task.isCompleted || task.dueDate == null) return Colors.grey;

    final now = DateTime.now();
    final difference = task.dueDate!.difference(now);

    if (difference.isNegative) { // Overdue
      return Colors.redAccent;
    } else if (difference.inDays < 1) { // Due today
      return Colors.orangeAccent;
    } else { // Due in the future
      return Colors.green;
    }
  }

  // Helper to build priority indicator
  Widget _buildPriorityIndicator(TaskPriority priority) {
    IconData icon;
    Color color;
    String tooltip;

    switch(priority) {
      case TaskPriority.high:
        icon = Icons.priority_high; // Using priority_high might be too alarming, consider alternatives
        // icon = Icons.keyboard_arrow_up;
        color = Colors.redAccent;
        tooltip = 'High Priority';
        break;
      case TaskPriority.medium:
         // icon = Icons.remove; // Horizontal line
         icon = Icons.keyboard_arrow_up; // Less intense than high
         color = Colors.orangeAccent;
         tooltip = 'Medium Priority';
        break;
      case TaskPriority.low:
      default:
         // icon = Icons.keyboard_arrow_down;
         icon = Icons.low_priority; // Specific low priority icon
         color = Colors.blueAccent;
         tooltip = 'Low Priority';
        break;
    }
    return Tooltip( // Show priority on hover/long-press
        message: tooltip,
        child: Icon(icon, color: color, size: 20.0));
  }

 // TODO: Implement _showEditTaskDialog - Needs a form similar to add task
 // void _showEditTaskDialog(BuildContext context, TaskProvider taskProvider, Task task) { ... }

}