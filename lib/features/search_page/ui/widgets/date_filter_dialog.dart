// lib/widgets/date_filter_dialog.dart
import 'package:flutter/material.dart';

class DateFilterDialog extends StatefulWidget {
  @override
  _DateFilterDialogState createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<DateFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text =
              "${picked.day}/${picked.month}/${picked.year}";
        } else {
          _endDate = picked;
          _endDateController.text =
              "${picked.day}/${picked.month}/${picked.year}";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("filter by the date"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _startDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Start date",
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, true),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _endDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "End Date",
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, false),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop({'startDate': _startDate, 'endDate': _endDate});
          },
          child: const Text("Filter"),
        ),
      ],
    );
  }
}
