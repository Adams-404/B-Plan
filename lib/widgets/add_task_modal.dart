import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskModal extends StatefulWidget {
  const AddTaskModal({Key? key}) : super(key: key);

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  DateTime? _selectedDueDate;
  TimeOfDay? _selectedDueTime;
  TaskPriority? _selectedPriority;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)), // Allow past dates slightly?
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // Allow up to 5 years in future
    );
    if (pickedDate != null && pickedDate != _selectedDueDate) {
      setState(() {
        _selectedDueDate = pickedDate;
        // Optionally keep time if date changes, or reset it
        // if (_selectedDueTime != null) {
        //   _selectedDueDate = DateTime(
        //     pickedDate.year,
        //     pickedDate.month,
        //     pickedDate.day,
        //     _selectedDueTime!.hour,
        //     _selectedDueTime!.minute,
        //   );
        // }
      });
      // Automatically open time picker after date is selected (optional)
      // _selectTime(context);
    }
  }

   // Function to show time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDueTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedDueTime) {
      setState(() {
        _selectedDueTime = pickedTime;
      });
    }
  }

  // Combine date and time into a DateTime object
   DateTime? get _finalDueDate {
      if (_selectedDueDate == null) return null;
      if (_selectedDueTime == null) return _selectedDueDate; // Return date only if no time picked

      return DateTime(
        _selectedDueDate!.year,
        _selectedDueDate!.month,
        _selectedDueDate!.day,
        _selectedDueTime!.hour,
        _selectedDueTime!.minute,
      );
   }


  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) { // Validate the form
      // Form is valid, proceed to add task
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.addTask(
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim().isEmpty
            ? null
            : _subtitleController.text.trim(), // Handle empty subtitle
        dueDate: _finalDueDate,
        priority: _selectedPriority,
      );
      Navigator.of(context).pop(); // Close the modal sheet
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding to account for keyboard overlap
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Form(
        key: _formKey,
        child: ListView( // Use ListView to prevent overflow if keyboard appears
          shrinkWrap: true, // Take only necessary space
          children: <Widget>[
            Text(
              'Add New Task',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title*',
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task title';
                }
                return null;
              },
              textInputAction: TextInputAction.next, // Move focus to next field
            ),
            const SizedBox(height: 16.0),
            // Subtitle/Notes Field
            TextFormField(
              controller: _subtitleController,
              decoration: const InputDecoration(
                labelText: 'Notes / Description',
                hintText: 'Add more details (optional)',
                border: OutlineInputBorder(),
                 prefixIcon: Icon(Icons.notes),
              ),
               maxLines: 3, // Allow multiple lines for notes
               textInputAction: TextInputAction.done, // Submit on done
               onFieldSubmitted: (_) => _submitForm(), // Optional: submit on keyboard done
            ),
            const SizedBox(height: 16.0),

             // --- Due Date and Time Picker ---
            Row(
              children: [
                 Expanded(
                  child: InkWell(
                     onTap: () => _selectDate(context),
                     child: InputDecorator(
                       decoration: const InputDecoration(
                         labelText: 'Due Date',
                          border: OutlineInputBorder(),
                           prefixIcon: Icon(Icons.calendar_today),
                       ),
                       child: Text(
                         _selectedDueDate == null
                             ? 'Select Date (Optional)'
                             : DateFormat.yMd().format(_selectedDueDate!), // Format date nicely
                          style: TextStyle(color: _selectedDueDate == null ? Colors.grey[600] : null),
                       ),
                     ),
                  ),
                 ),
                // Optional: Clear Date Button
                 if (_selectedDueDate != null)
                   IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear Date',
                      onPressed: () => setState(() {
                         _selectedDueDate = null;
                         _selectedDueTime = null; // Also clear time if date is cleared
                      }),
                    ),
                 const SizedBox(width: 8.0),
                 // Time Picker Button (only enabled if date is selected)
                 ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedDueTime == null ? 'Time' : _selectedDueTime!.format(context)),
                    onPressed: _selectedDueDate == null ? null : () => _selectTime(context),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
                 ),
              ],
            ),
            const SizedBox(height: 16.0),

            // --- Priority Selector ---
             DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                hint: const Text('Select Priority (Optional)'),
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priority.name.substring(0, 1).toUpperCase() + priority.name.substring(1)), // Capitalize first letter
                  );
                }).toList(),
                onChanged: (TaskPriority? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
                 // Optional: Add a clear button for priority
                  // Use suffixIcon inside InputDecoration for this
              ),

            const SizedBox(height: 24.0),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal
                  },
                ),
                const SizedBox(width: 8.0),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_task),
                  label: const Text('Add Task'),
                  onPressed: _submitForm, // Call submit handler
                   style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      // backgroundColor: Theme.of(context).colorScheme.primary, // Optional: Style primary action
                      // foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
             const SizedBox(height: 16.0), // Extra padding at the bottom
          ],
        ),
      ),
    );
  }
}
