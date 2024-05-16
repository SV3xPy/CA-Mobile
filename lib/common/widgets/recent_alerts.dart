import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/countdown_painter.dart';
import 'package:ca_mobile/models/alert_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentAlerts extends StatefulWidget {
  const RecentAlerts({super.key});

  @override
  State<RecentAlerts> createState() => _RecentAlertsState();
}

class _RecentAlertsState extends State<RecentAlerts> {
  DateFormat dateFormat = DateFormat("hh:mm a");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: recentAlerts.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        Alert alert = recentAlerts[index];
        int hoursLeft = DateTime.now().difference(alert.time).inHours;
        hoursLeft = hoursLeft < 0 ? hoursLeft : 0;
        double percent = hoursLeft / 48;
        return Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                bottom: 30.0,
              ),
              height: 130.0,
              width: 15.0,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    30.0,
                  ),
                  bottomLeft: Radius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 30.0,
                ),
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  20.0,
                  20.0,
                  10.0,
                ),
                height: 130.0,
                width: 326.0,
                decoration: const BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      12.0,
                    ),
                    bottomRight: Radius.circular(
                      12.0,
                    ),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          alert.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
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
                              "${DateTime.now().weekday == alert.time.weekday ? "Hoy" : DateFormat.EEEE().format(alert.time)}, ${dateFormat.format(alert.time)}",
                              style: const TextStyle(
                                color: txtColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.bookmark,
                              color: Theme.of(context).hintColor,
                              size: 17.0,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              alert.subject,
                              style: const TextStyle(
                                color: txtColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Positioned(
                      right: 0.0,
                      child: CustomPaint(
                        foregroundPainter: CountdownPainter(
                          bgColor: bgColor,
                          lineColor: _getColor(context, percent),
                          percent: percent,
                          width: 4.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "$hoursLeft",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "hours left",
                                style: TextStyle(
                                  color: _getColor(context, percent),
                                  fontSize: 13.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _getColor(BuildContext context, double percent) {
    if (percent >= 0.35) {
      return Theme.of(context).hintColor;
    }
    return hourColor;
  }
}