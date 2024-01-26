import 'package:flutter/material.dart';
import 'account_delete.dart';
import 'change_password.dart';

class Setting extends StatefulWidget {
  Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigatorBar(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  final List<Widget> _pages = [
    ChangePassword(),
    DeleteAccount(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _navigatorBar,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
    );
  }
}
