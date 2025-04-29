import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
 const HistoryScreen({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   // Placeholder: Replace with actual History screen UI
   return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
      ),
      body: const Center(
        child: Text('Completed tasks grouped by day will appear here.'),
      ),
   );
 }
}
