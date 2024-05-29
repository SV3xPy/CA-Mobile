import 'package:ca_mobile/common/widgets/header.dart';
import 'package:ca_mobile/common/widgets/recent_alerts.dart';
import 'package:ca_mobile/common/widgets/recent_homeworks.dart';
import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //final usersAsyncValue = ref.watch(getUsersProvider);
    final tSwitchProvider = ref.watch(themeSwitchProvider);
    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    final bgContainer =
        tSwitchProvider ? const Color(0xFF202328) : const Color(0xffdfdcd7);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const Header(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 30.0,
          //   ),
          //   child: TextField(
          //     style: TextStyle(
          //       color: txtColor,
          //     ),
          //     cursorColor: txtColor,
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       fillColor: bgContainer,
          //       filled: true,
          //       hintText: "Buscar",
          //       hintStyle: TextStyle(
          //         color: txtColor,
          //       ),
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: iconColor,
          //         size: 26.0,
          //       ),
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(
          //           30.0,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 30.0,
          // ),
          Container(
            // padding: const EdgeInsets.all(
            //   35.0,
            // ),
            padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
            decoration: BoxDecoration(
              color: bgContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  50.0,
                ),
                topRight: Radius.circular(
                  50.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Alertas recientes",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const RecentAlerts(),
                // Center(
                //   child: Text(
                //     "Ver todos",
                //     style: TextStyle(
                //       color: iconColor,
                //       fontSize: 15.0,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Tareas recientes",
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const RecentHomeworks(),
                // Center(
                //   child: Text(
                //     "Ver todos",
                //     style: TextStyle(
                //       color: iconColor,
                //       fontSize: 15.0,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
