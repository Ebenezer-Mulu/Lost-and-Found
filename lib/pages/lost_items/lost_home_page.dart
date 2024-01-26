import 'package:flutter/material.dart';


import '../../components/bottomnavbar.dart';
import 'lost_item.dart';
import 'view_lost_item.dart';

class LostPage extends StatefulWidget {
  LostPage({Key? key}) : super(key: key);

  @override
  State<LostPage> createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void _navigatorBar(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<Widget> _pages = [
    LostItemPage(),
    const ViewLostItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomNavBar(
          onTabChange: _navigatorBar, selectedIndex: _selectedIndex),
      body: _pages[_selectedIndex],
    );
  }
}
