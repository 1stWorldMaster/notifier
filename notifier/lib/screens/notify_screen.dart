import 'package:flutter/material.dart';
import '../models/notify.dart';
import '../services/shared_prefs_service.dart';
import '../widgets/date_time_picker.dart';
import 'display_screen.dart';

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
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    List<Notify> loadedNotifications = await SharedPrefsService.loadNotifications();
    setState(() {
      notifications = loadedNotifications;
    });
  }

  Future<void> _saveNotifications() async {
    await SharedPrefsService.saveNotifications(notifications);
  }

  void _addNotification() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title cannot be empty")));
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

    _saveNotifications();
    _clearFields();
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDate = null;
    _selectedTime = null;
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (pickedDate != null) setState(() => _selectedDate = pickedDate);
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) setState(() => _selectedTime = pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Notification")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 10),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 10),
            DateTimePicker(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              onPickDate: _pickDate,
              onPickTime: _pickTime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addNotification, child: const Text("Save Notification")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DisplayScreen(notifications: notifications)),
                );
              },
              child: const Text("View Notifications"),
            ),
          ],
        ),
      ),
    );
  }
}
