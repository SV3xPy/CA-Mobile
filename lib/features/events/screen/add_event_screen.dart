import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add_event';
  final Event? event;
  const AddEventScreen({super.key, this.event});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(
        const Duration(
          hours: 2,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nuevo evento",
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
