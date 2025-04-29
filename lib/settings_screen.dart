import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
 const SettingsScreen({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   // Placeholder: Replace with actual Settings screen UI
   return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          // Placeholder settings items
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            // TODO: Add Switch to toggle dark mode
            trailing: Switch(
                value: false, // Placeholder value
                onChanged: null, // TODO: Implement theme change
              ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
             // TODO: Add Switch to toggle notifications (visual only)
             trailing: Switch(
                value: true, // Placeholder value
                onChanged: null, // TODO: Implement setting change
              ),
          ),
           ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Info'),
            // TODO: Navigate to an App Info screen or show a dialog
            onTap: null,
          ),
        ],
      ),
   );
 }
}
