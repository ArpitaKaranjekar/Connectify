import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/contacts_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Logs Access',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AccessCallLogsPage(),
    );
  }
}

class AccessCallLogsPage extends StatelessWidget {
  const AccessCallLogsPage({super.key});

  // Function to request permission and fetch contacts
  Future<void> _requestAccess(BuildContext context) async {
    // Request permissions for call logs and contacts
    PermissionStatus contactsPermission = await Permission.contacts.request();
    PermissionStatus callLogsPermission = await Permission.phone.request();

    if (contactsPermission.isGranted && callLogsPermission.isGranted) {
      // If both permissions are granted, navigate to the contacts screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ContactsListScreen()),
      );
    } else {
      // Show error message if permissions are denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permissions Denied. Please allow access.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Container
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/phone.png', // Ensure this path is correct
                  width: 590,
                  height: 596,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Access Your Call Logs",
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "We need access to your contacts and call logs to help you connect and manage your communication seamlessly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Allow Access Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () => _requestAccess(context),
            child: const Text(
              "Allow Access",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Contacts List Page
