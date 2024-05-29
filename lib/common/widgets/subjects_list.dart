import 'package:auto_size_text/auto_size_text.dart';
import 'package:ca_mobile/common/widgets/loader.dart';
import 'package:ca_mobile/features/subjects/controller/subject_controller.dart';
import 'package:ca_mobile/features/subjects/screen/add_subject_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/models/subject_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Options {
  update,
  delete,
}

class SubjectsList extends ConsumerStatefulWidget {
  const SubjectsList({super.key});

  @override
  ConsumerState<SubjectsList> createState() => _SubjectsListState();
}

class _SubjectsListState extends ConsumerState<SubjectsList>
    with WidgetsBindingObserver {
  String selectedId = "";
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

  PopupMenuItem _buildPopupMenuItem(
    String title,
    IconData iconData,
    int position,
    Color iconColor,
    Color txtColor,
  ) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          Text(
            title,
            style: TextStyle(
              color: txtColor,
            ),
          ),
        ],
      ),
    );
  }

  _onMenuItemSelected(int popupMenuItemIndex, String subjectId) {
    if (popupMenuItemIndex == Options.update.index) {
      Navigator.pushNamed(
        context,
        AddSubjectScreen.routeName,
        arguments: subjectId,
      );
    } else {
      ref.read(subjectControllerProvider).deleteSubject(subjectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgContainer =
        tSwitchProvider ? const Color(0xFF282B30) : const Color(0xffd7d4cf);
    return StreamBuilder<List<SubjectModel>>(
      stream: ref.read(subjectControllerProvider).getAllSubjectDataStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<SubjectModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 120),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              List<SubjectModel> subject = snapshot.data!;
              return Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 30.0,
                    ),
                    height: 100.0,
                    width: 15.0,
                    decoration: BoxDecoration(
                      color: subject[index].color,
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
                      height: 100.0,
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
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  subject[index].subject,
                                  style: TextStyle(
                                    color: txtColor,
                                    fontSize: 18.0,
                                  ),
                                  maxLines: 1,
                                  minFontSize:
                                      12, // Establece el tamaño mínimo del texto
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
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
                                      subject[index].teacherName,
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
                              )
                            ],
                          ),
                          Positioned(
                            right: 0.0,
                            bottom: 20,
                            left: 280,
                            child: PopupMenuButton(
                              onSelected: (value) {
                                _onMenuItemSelected(value, subject[index].id);
                                selectedId = subject[index].id;
                              },
                              itemBuilder: (context) => [
                                _buildPopupMenuItem(
                                  "Editar",
                                  Icons.edit,
                                  Options.update.index,
                                  iconColor,
                                  txtColor,
                                ),
                                _buildPopupMenuItem(
                                  "Borrar",
                                  Icons.delete,
                                  Options.delete.index,
                                  iconColor,
                                  txtColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return const Loader();
      },
    );
  }
}
