import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const BottomNavBar(
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
              Icons.report,
              color: Colors.white,
            ),
            title: const Text(
              'Report Lost item',
              style: TextStyle(color: Colors.white),
            ),
            inactiveColor: Colors.grey[400],
            activeColor: Colors.grey.shade700,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.remove_red_eye_rounded,
              color: Colors.white,
            ),
            title: const Text(
              'View Lost Item',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
