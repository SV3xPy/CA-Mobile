import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class RecentHomeworks extends StatefulWidget {
  const RecentHomeworks({super.key});

  @override
  State<RecentHomeworks> createState() => _RecentHomeworksState();
}

class _RecentHomeworksState extends State<RecentHomeworks> {
  DateFormat dateFormat = DateFormat("hh:mm a");
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: recentEvents.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        Event event = recentEvents[index];
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
                  color: cardColor,
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
                          event.title,
                          style: const TextStyle(
                            color: Colors.white,
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
                              color: Theme.of(context).hintColor,
                              size: 17.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "${DateTime.now().weekday == event.dueTime.weekday ? "Hoy" : DateFormat.EEEE().format(event.dueTime)}, ${dateFormat.format(event.dueTime)}",
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
                    _todoButton(event)
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _todoButton(Event event) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          event.isDone = !event.isDone;
        });
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          CircleBorder(
            side: BorderSide(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          event.isDone ? Theme.of(context).hintColor : Colors.transparent,
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
