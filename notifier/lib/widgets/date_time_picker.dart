import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const DateTimePicker({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate == null
                ? "No date selected"
                : "Date: ${selectedDate!.toLocal()}".split(' ')[0]),
            ElevatedButton(onPressed: onPickDate, child: const Text("Pick Date")),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedTime == null ? "No time selected" : "Time: ${selectedTime!.format(context)}"),
            ElevatedButton(onPressed: onPickTime, child: const Text("Pick Time")),
          ],
        ),
      ],
    );
  }
}
