import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class ProfileBottomNavBar extends StatelessWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const ProfileBottomNavBar(
      {Key? key, required this.onTabChange, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.center,
        selectedIndex: selectedIndex,
        onItemSelected: onTabChange,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: [
          BottomNavyBarItem(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            inactiveColor: Colors.grey[400],
            activeColor: Colors.grey.shade700,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.person_search,
              color: Colors.white,
            ),
            title: const Text(
              'View Lost ',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            title: const Text(
              'View Found ',
              style: TextStyle(color: Colors.white),
            ),
            inactiveColor: Colors.grey[400],
            activeColor: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }
}
