import 'package:ca_mobile/features/theme/provider/theme_provider.dart';
import 'package:ca_mobile/screens/calendar_screen.dart';
import 'package:ca_mobile/screens/home_screen.dart';
import 'package:ca_mobile/screens/schedule_screen.dart';
import 'package:ca_mobile/screens/settings_screen.dart';
import 'package:ca_mobile/screens/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

enum Options {
  ajustes,
}

class BottomNavigation extends ConsumerStatefulWidget {
  static const routeName = '/main';
  final int initialTabIndex; // Parámetro para el índice de la pestaña inicial
  const BottomNavigation({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedTab = 0;
  late Widget _currentPage;
  late HomeScreen _homeScreen;
  late SubjectsScreen _subjectsScreen;
  late ScheduleScreen _scheduleScreen;
  late List<Widget> _pages;
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    _homeScreen = const HomeScreen();
    _scheduleScreen = const ScheduleScreen();
    _subjectsScreen = const SubjectsScreen();
    _pages = [
      _homeScreen,
      _scheduleScreen,
      _subjectsScreen,
    ];
    _currentPage = _pages[widget
        .initialTabIndex]; // Usar el índice inicial de la pestaña para establecer la página actual
    _selectedTab = widget.initialTabIndex;
    tabBarController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController.dispose();
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

  _onMenuItemSelected(int popupMenuItemIndex) {
    if (popupMenuItemIndex == Options.ajustes.index) {
      Navigator.pushNamed(
        context,
        SettingsScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tSwitchProvider = ref.watch(themeSwitchProvider);

    final iconColor =
        tSwitchProvider ? const Color(0xFF63CF93) : const Color(0xFF9c306c);
    final txtColor = tSwitchProvider ? Colors.white : Colors.black;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Row(
            children: [
              SvgPicture.asset(
                "assets/grad_cap.png",
                height: 28.8,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "EduAgenda",
                style: TextStyle(
                  color: txtColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                _onMenuItemSelected(value);
              },
              itemBuilder: (context) => [
                _buildPopupMenuItem("Ajustes", Icons.settings,
                    Options.ajustes.index, iconColor, txtColor),
              ],
            ),
          ],
          bottom: _currentPage == _scheduleScreen
              ? TabBar(
                  controller: tabBarController,
                  tabs: const [
                    Tab(
                      text: "Horario",
                    ),
                    Tab(
                      text: "Calendario",
                    ),
                  ],
                )
              : null,
        ),
        body: Stack(
          children: <Widget>[
            _currentPage == _scheduleScreen
                ? TabBarView(
                    controller: tabBarController,
                    children: const [
                      ScheduleScreen(),
                      CalendarScreen(),
                    ],
                  )
                : _currentPage,
            _bottomNavigator(),
          ],
        ),
      ),
    );
  }

  _bottomNavigator() {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            30.0,
          ),
          topRight: Radius.circular(
            30.0,
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //backgroundColor: Theme.of(context).colorScheme.background,
          currentIndex: _selectedTab,
          onTap: (int tab) {
            setState(() {
              _selectedTab = tab;
              if (tab == 0 || tab == 1 || tab == 2) {
                _currentPage = _pages[tab];
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 35.0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: 35.0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_work,
                size: 35.0,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
