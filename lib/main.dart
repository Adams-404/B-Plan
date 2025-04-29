import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import screen files
import 'today_screen.dart';
import 'all_tasks_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

// Import providers
import 'providers/task_provider.dart';

// Import widgets
import 'widgets/add_task_modal.dart'; // Import the new modal widget

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const BPlanApp(),
    ),
  );
}

class BPlanApp extends StatelessWidget {
  const BPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B-Plan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
         bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
         floatingActionButtonTheme: const FloatingActionButtonThemeData(
           backgroundColor: Colors.blueAccent,
           foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TodayScreen(),
    AllTasksScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showFab = _selectedIndex == 0 || _selectedIndex == 1;

    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                 _showAddTaskModal(context); // Use the new modal function
              },
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
              elevation: 2.0,
            )
          : null,
       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Updated function to show the AddTaskModal using a bottom sheet
  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Make the modal scrollable and expand with content
      isScrollControlled: true,
      // Rounded corners for the modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        // Return the AddTaskModal widget we created
        return const AddTaskModal();
      },
    );
  }

  // Keep the old dialog function commented out or remove it if not needed
  /*
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // ... old AlertDialog code ...
      },
    );
  }
  */
}
