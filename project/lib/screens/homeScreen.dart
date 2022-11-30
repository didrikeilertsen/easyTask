import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/profile/profile_screen.dart';
import 'package:project/screens/project/project_overview_screen.dart';
import '../styles/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final screens = [
    const ProjectOverviewScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Themes.primaryColor,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.squaresFour),
            label: 'projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.userCircle),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
