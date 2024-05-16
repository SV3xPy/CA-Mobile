import 'package:ca_mobile/colors.dart';
import 'package:ca_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';

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
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _homeScreen = const HomeScreen();
    _pages = [_homeScreen];
    _currentPage = _homeScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
