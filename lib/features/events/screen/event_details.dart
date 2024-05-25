import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends ConsumerWidget {
  static const routeName = '/event-details';
  final EventModel event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles"),
        leading: const CloseButton(),
        actions: buildViewingActions(
          context,
          event,
          iconColor,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text(
            event.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: txtColor,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Desde",
                style: TextStyle(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat('EEE, MMM d, yyyy, HH:mm').format(event.from),
                style: TextStyle(
                  color: txtColor,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hasta",
                style: TextStyle(
                    color: txtColor, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                DateFormat('EEE, MMM d, yyyy, HH:mm').format(event.to),
                style: TextStyle(
                  color: txtColor,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          event.subject == ""
              ? Container()
              : Text(
                  event.subject,
                  style: TextStyle(
                    color: txtColor,
                  ),
                ),
          const SizedBox(
            height: 24,
          ),
          Text(
            event.type,
            style: TextStyle(
              color: txtColor,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            event.description,
            style: TextStyle(
              color: txtColor,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildViewingActions(
    BuildContext context,
    EventModel event,
    Color iconColor,
  ) {
    return [
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.edit,
          color: iconColor,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.delete,
          color: iconColor,
        ),
      ),
    ];
  }
}
