//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedPage;
  final void Function(int) onDestinationSelected;

  const BottomNav(
      {super.key,
      required this.selectedPage,
      required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        onDestinationSelected(index);
      },
      backgroundColor: Colors.white,
      indicatorColor: Colors.red,
      selectedIndex: selectedPage,
      destinations: const <Widget>[
        NavigationDestination(
          // Dashboard screen
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          // Transaction screen
          selectedIcon: Icon(Icons.business),
          icon: Icon(Icons.business_outlined),
          label: 'Trxn',
        ),
        NavigationDestination(
          // Calendar screen
          selectedIcon: Icon(Icons.calendar_month),
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendar',
        ),
        NavigationDestination(
          // User profile screen
          selectedIcon: Icon(Icons.people_alt),
          icon: Icon(Icons.people_alt_outlined),
          label: 'Chat',
        ),
        NavigationDestination(
          // User profile screen
          selectedIcon: Icon(Icons.chat),
          icon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
      ],
    );
  }
}
