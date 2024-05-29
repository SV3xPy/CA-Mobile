import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/bottom_navigation_bar.dart';
import 'package:ca_mobile/features/events/controller/event_controller.dart';
import 'package:ca_mobile/features/events/screen/add_event_screen.dart';
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
          ref,
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
    WidgetRef ref,
    BuildContext context,
    EventModel event,
    Color iconColor,
  ) {
    return [
      IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddEventScreen.routeNameUpdate,
            arguments: event,
          );
        },
        icon: Icon(
          Icons.edit,
          color: iconColor,
        ),
      ),
      IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("¿Estas seguro?"),
                  content: const Text("Esta accion no se puede revertir"),
                  actions: <Widget>[
                    TextButton(
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(tabColor),
                      ),
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(tabColor),
                      ),
                      child: const Text('Confirmar'),
                      onPressed: () {
                        ref.read(eventControllerProvider).deleteEvent(event.id);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomNavigation(
                                initialTabIndex: 1,
                              ),
                            ),
                            (route) => false);
                      },
                    ),
                  ],
                );
              });
        },
        icon: Icon(
          Icons.delete,
          color: iconColor,
        ),
      ),
    ];
  }
}
