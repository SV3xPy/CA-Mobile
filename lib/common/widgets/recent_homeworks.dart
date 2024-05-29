import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/common/widgets/error.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/subjects/controller/subject_controller.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';
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
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgContainer =
        tSwitchProvider ? const Color(0xFF282B30) : const Color(0xffd7d4cf);
    return FutureBuilder(
      future: ref.read(subjectControllerProvider).getAllSubjectData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length, //recentEvents.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              final subject = snapshot.data![index];
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
                        color: bgContainer,
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
                              Expanded(
                                child: SizedBox(
                                  width: 250,
                                  child: AutoSizeText(
                                    subject.subject,
                                    style: TextStyle(
                                      color: txtColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    minFontSize:
                                        12, // Establece el tamaño mínimo del texto
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: iconColor,
                                    size: 17.0,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: AutoSizeText(
                                      subject
                                          .teacherName, //,${DateTime.now().weekday == event.dueTime.weekday ? "Hoy" : DateFormat.EEEE().format(event.dueTime)}, ${dateFormat.format(event.dueTime)}",
                                      style: TextStyle(
                                        color: txtColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      minFontSize:
                                          12, // Establece el tamaño mínimo del texto
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //_todoButton(event, iconColor)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return ErrorScreen(
            error: "${snapshot.error}",
          );
        }
        return const Loader();
      },
    );
  }

  _todoButton(EventModel event, Color iconColor) {
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
              color: iconColor,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          event.isDone ? iconColor : Colors.transparent,
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
