import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> with WidgetsBindingObserver {
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
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10.0,
        30.0,
        10.0,
        30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage(""),
          ),
          Text(
            "Nombre usuario",
            style: TextStyle(
              color: txtColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
