import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentHomeworks extends ConsumerStatefulWidget {
  const RecentHomeworks({super.key});

  @override
  ConsumerState<RecentHomeworks> createState() => _RecentHomeworksState();
}

class _RecentHomeworksState extends ConsumerState<RecentHomeworks>
    with WidgetsBindingObserver {
  DateFormat dateFormat = DateFormat("hh:mm a");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2, //recentEvents.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        //Event event = recentEvents[index];
        return Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 30.0,
                ),
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  20.0,
                  10.0,
                  10.0,
                ),
                height: 100.0,
                width: 341.0,
                decoration: BoxDecoration(
                  color: tSwitchProvider
                      ? const Color(0xFF282B30)
                      : const Color(0xffd7d4cf),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          //event.title,
                          "",
                          style: TextStyle(
                            color:
                                tSwitchProvider ? Colors.white : Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: tSwitchProvider
                                  ? const Color(0xFF63CF93)
                                  : const Color(0xFF9c306c),
                              size: 17.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "", //,${DateTime.now().weekday == event.dueTime.weekday ? "Hoy" : DateFormat.EEEE().format(event.dueTime)}, ${dateFormat.format(event.dueTime)}",
                              style: const TextStyle(
                                color: txtColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //_todoButton(event, tSwitchProvider)
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _todoButton(Event event, bool tSwitch) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          //event.isDone = !event.isDone;
        });
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          CircleBorder(
            side: BorderSide(
              color:
                  tSwitch ? const Color(0xFF63CF93) : const Color(0xFF9c306c),
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          event.isDone
              ? tSwitch
                  ? const Color(0xFF63CF93)
                  : const Color(0xFF9c306c)
              : Colors.transparent,
        ),
      ),
      child: event.isDone
          ? const Icon(
              Icons.check,
              color: Colors.white,
            )
          : null,
    );
  }
}
