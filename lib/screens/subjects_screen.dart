import 'package:ca_mobile/common/widgets/subjects_list.dart';
import 'package:ca_mobile/features/subjects/screen/add_subject_screen.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectsScreen extends ConsumerStatefulWidget {
  const SubjectsScreen({super.key});

  @override
  ConsumerState<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends ConsumerState<SubjectsScreen>
    with WidgetsBindingObserver {
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
    final datetimeBorder =
        tSwitchProvider ? const Color(0xFFBE9020) : Colors.black12;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 60.0,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AddSubjectScreen.routeName,
            );
          },
          backgroundColor: iconColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: const SubjectsList(),
    );
  }
}
