import 'package:flutter/material.dart';

import '../../components/profile_bottom_navbar.dart';
import 'edit_profile.dart';
import 'found.dart';
import 'lost.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _navigatorBar(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index.clamp(0, _pages.length - 1);
      });
    }
  }

  final List<Widget> _pages = [
    const EditProfile(),
    LostPost(),
    FoundPost(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: ProfileBottomNavBar(
          onTabChange: _navigatorBar, selectedIndex: _selectedIndex),
      body: _pages[_selectedIndex],
    );
  }
}
