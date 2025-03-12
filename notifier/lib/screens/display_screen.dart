import 'package:flutter/material.dart';
import '../models/notify.dart';

class DisplayScreen extends StatelessWidget {
  final List<Notify> notifications;

  const DisplayScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Notifications")),
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications available"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notify = notifications[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(notify.title ?? "No Title"),
              subtitle: Text(notify.description ?? "No Description"),
            ),
          );
        },
      ),
    );
  }
}
