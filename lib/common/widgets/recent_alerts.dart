import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/common/widgets/countdown_painter.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/events/controller/event_controller.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/alert_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecentAlerts extends ConsumerStatefulWidget {
  const RecentAlerts({super.key});

  @override
  ConsumerState<RecentAlerts> createState() => _RecentAlertsState();
}

class _RecentAlertsState extends ConsumerState<RecentAlerts>
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
    Color? alertDown =
        tSwitchProvider ? const Color(0xFFF5C35A) : const Color(0xffBB342F);
    Color? alertUp =
        tSwitchProvider ? const Color(0xFFFA8334) : const Color(0xFF119822);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgContainer =
        tSwitchProvider ? const Color(0xFF282B30) : const Color(0xffd7d4cf);
    return FutureBuilder(
      future: ref.read(eventControllerProvider).getAllEventsData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              final alert = snapshot.data![index];
              //int hoursLeft = DateTime.now().difference(alert.time).inHours;
              int hoursLeft = alert.to.difference(DateTime.now()).inHours;
              hoursLeft = hoursLeft > 0 ? hoursLeft : 0;
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
                      color: iconColor,
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
                      decoration: BoxDecoration(
                        color: bgContainer,
                        borderRadius: const BorderRadius.only(
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
                                style: TextStyle(
                                  color: txtColor,
                                  fontSize: 18.0,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: iconColor,
                                    size: 17.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "${DateTime.now().weekday == alert.to.weekday ? "Hoy" : DateFormat.EEEE().format(alert.to)}, ${dateFormat.format(alert.to)}",
                                    style: TextStyle(
                                      color: txtColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                width: 170,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.bookmark,
                                      color: iconColor,
                                      size: 17.0,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: AutoSizeText(
                                        alert.subject,
                                        style: TextStyle(
                                          color: txtColor,
                                          fontSize: 15.0,
                                        ),
                                        maxLines: 1,
                                        minFontSize:
                                            12, // Establece el tamaño mínimo del texto
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            child: CustomPaint(
                              foregroundPainter: CountdownPainter(
                                bgColor: bgColor,
                                lineColor: _getColor(
                                    context, percent, alertUp, alertDown),
                                percent: percent,
                                width: 4.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "$hoursLeft",
                                      style: TextStyle(
                                        color: txtColor,
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "hours left",
                                      style: TextStyle(
                                        color: _getColor(context, percent,
                                            alertUp, alertDown),
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
        } else if (snapshot.hasError) {
          return ErrorScreen(error: "${snapshot.error}");
        }
        return const Loader();
      },
    );
  }

  _getColor(BuildContext context, double percent, Color? up, Color? down) {
    if (percent >= 0.35) {
      return up;
    }
    return down;
  }
}
