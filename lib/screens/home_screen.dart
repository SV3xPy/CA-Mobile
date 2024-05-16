import 'package:ca_mobile/common/widgets/header.dart';
import 'package:ca_mobile/common/widgets/recent_alerts.dart';
import 'package:ca_mobile/common/widgets/recent_homeworks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ca_mobile/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const Header(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: TextField(
              style: const TextStyle(
                color: txtColor,
              ),
              cursorColor: txtColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Theme.of(context).primaryColor,
                filled: true,
                hintText: "Buscar",
                hintStyle: const TextStyle(
                  color: txtColor,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: txtColor,
                  size: 26.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    30.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            // padding: const EdgeInsets.all(
            //   35.0,
            // ),
            padding: const EdgeInsets.fromLTRB(15, 35, 15, 35),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
                const Text(
                  "Alertas recientes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const RecentAlerts(),
                Center(
                  child: Text(
                    "Ver todos",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  "Tareas recientes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RecentHomeworks(),
                Center(
                  child: Text(
                    "Ver todos",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
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