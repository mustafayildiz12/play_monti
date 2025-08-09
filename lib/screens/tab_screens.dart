import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:play_monti/constants/app_colors.dart';
import 'package:play_monti/screens/Home/home_screen.dart';
import 'package:play_monti/screens/dummy_screens.dart';
import 'package:play_monti/screens/onboarding_flow.dart';

class MainTabNavigator extends StatefulWidget {
  const MainTabNavigator({super.key});

  @override
  State<MainTabNavigator> createState() => _MainTabNavigatorState();
}

class _MainTabNavigatorState extends State<MainTabNavigator> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const CalendarScreen(),
    const OnboardingFlow(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.kDarkGreenColor,
        unselectedItemColor: const Color(0xFF999999),
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.calendar_outline),
            activeIcon: Icon(Ionicons.calendar),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.trophy_outline),
            activeIcon: Icon(Ionicons.trophy),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.heart_outline),
            activeIcon: Icon(Ionicons.heart),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.settings_outline),
            activeIcon: Icon(Ionicons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
