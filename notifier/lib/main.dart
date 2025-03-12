// import 'package:flutter/material.dart';
// import 'package:notifier/home_page.dart'; // Corrected import
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotifyScreen(),
    );
  }
}

class Notify {
  DateTime? date;
  TimeOfDay? time;
  String? title;
  String? description;

  Notify({this.date, this.time, this.title, this.description});

  // Convert Notify object to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'title': title,
      'description': description,
    };
  }

  // Convert JSON to Notify object
  factory Notify.fromJson(Map<String, dynamic> json) {
    List<String>? timeParts = json['time']?.split(':');
    return Notify(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: timeParts != null ? TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])) : null,
      title: json['title'],
      description: json['description'],
    );
  }
}

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Notify> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications(); // Load saved data when the app starts
  }

  // Load saved notifications from SharedPreferences
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('notifications');
    if (savedData != null) {
      List<dynamic> jsonList = jsonDecode(savedData);
      setState(() {
        notifications = jsonList.map((json) => Notify.fromJson(json)).toList();
      });
    }
  }

  // Save notifications to SharedPreferences
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = notifications.map((notify) => notify.toJson()).toList();
    await prefs.setString('notifications', jsonEncode(jsonList));
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _addNotification() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    setState(() {
      notifications.add(
        Notify(
          date: _selectedDate,
          time: _selectedTime,
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      );
    });

    _saveNotifications(); // Save the updated notifications list
    _titleController.clear();
    _descriptionController.clear();
    _selectedDate = null;
    _selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Notification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedDate == null
                    ? "No date selected"
                    : "Date: ${_selectedDate!.toLocal()}".split(' ')[0]),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedTime == null
                    ? "No time selected"
                    : "Time: ${_selectedTime!.format(context)}"),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text("Pick Time"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addNotification,
                child: const Text("Save Notification"),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayScreen(notifications: notifications),
                    ),
                  );
                },
                child: const Text("View Notifications"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Date: ${notify.date?.toLocal().toString().split(' ')[0] ?? 'Not set'}"),
                  Text(
                      "Time: ${notify.time?.format(context) ?? 'Not set'}"),
                  Text("Description: ${notify.description ?? 'No Description'}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
