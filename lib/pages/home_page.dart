import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_items/components/list_tile.dart';
import 'package:lost_and_found_items/pages/home_content.dart';
import 'package:lost_and_found_items/pages/users.dart';
import 'package:lost_and_found_items/pages/setting.dart';

import 'found_items/found_home.dart';
import 'lost_items/lost_home_page.dart';
import 'profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool _isNewMessageReceived = false;

  int _selectedIndex = 0;

  void _navigatorBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    _printSelectedPageName();
  }

  String _printSelectedPageName() {
    if (_selectedIndex >= 0 && _selectedIndex < _pages.length) {
      Widget selectedPage = _pages[_selectedIndex];
      String pageName = selectedPage.toString();
      return pageName;
    }
    return "Error";
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void updateNewMessageReceived(bool isNewMessageReceived) {
    setState(() {
      _isNewMessageReceived = isNewMessageReceived;
    });
  }

  final List<Widget> _pages = [
    const Home(),
    Profile(),
    LostPage(),
    const FoundPage(),
    Setting(),
    Users(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              color: Colors.white,
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            _printSelectedPageName(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notification_important),
                  onPressed: () {},
                  color: _isNewMessageReceived ? Colors.red : Colors.blue,
                ),
                Text(
                  user.email!,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'lib/images/logo.jpg',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.home,
                    text: "Home",
                    onTap: () => _navigatorBar(0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.person,
                    text: "Profile",
                    onTap: () => _navigatorBar(1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.lock,
                    text: "Lost Item",
                    onTap: () => _navigatorBar(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.lock,
                    text: "Found Item",
                    onTap: () => _navigatorBar(3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.settings,
                    text: "Setting",
                    onTap: () => _navigatorBar(4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTiles(
                    icon: Icons.settings,
                    text: "Users",
                    onTap: () => _navigatorBar(5),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTiles(
                icon: Icons.logout,
                text: "Logout",
                onTap: () => {signUserOut()},
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
