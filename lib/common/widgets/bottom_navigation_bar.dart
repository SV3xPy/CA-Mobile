import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/screens/home_screen.dart';
import 'package:ca_mobile/screens/schedule_screen.dart';
import 'package:ca_mobile/screens/subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigation extends StatefulWidget {
  static const routeName = '/main';
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedTab = 0;
  late Widget _currentPage;
  late HomeScreen _homeScreen;
  late SubjectsScreen _subjectsScreen;
  late ScheduleScreen _scheduleScreen;
  late List<Widget> _pages;

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
    _currentPage = _homeScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
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
            const Text(
              "EduAgenda",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage(""),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: <Widget>[
          _currentPage,
          _bottomNavigator(),
        ],
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
          backgroundColor: Theme.of(context).colorScheme.background,
          currentIndex: _selectedTab,
          onTap: (int tab) {
            setState(() {
              _selectedTab = tab;
              if (tab == 0 || tab == 1) {
                _currentPage = _pages[tab];
              }
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 35.0,
                color:
                    _selectedTab == 0 ? Theme.of(context).hintColor : txtColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
                size: 35.0,
                color:
                    _selectedTab == 1 ? Theme.of(context).hintColor : txtColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_work,
                size: 35.0,
                color:
                    _selectedTab == 2 ? Theme.of(context).hintColor : txtColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.comment,
                size: 35.0,
                color:
                    _selectedTab == 3 ? Theme.of(context).hintColor : txtColor,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
