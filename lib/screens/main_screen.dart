//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/screens/login_screen.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:deal_diligence/Providers/trxn_provider.dart';
import 'package:deal_diligence/screens/appointment_calendar.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:deal_diligence/screens/company_dash_board.dart';
// import 'package:deal_diligence/screens/trxn_home.dart';
// import 'package:deal_diligence/screens/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  // Added this for BottomNavigationBar sync
  // This allows the children to get the state of this page
  static MainScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>();
  }

  @override
  //MainScreenState
  createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final auth = FirebaseAuth.instance;
  int _pageIndex = 0;

  final List<Widget> appScreens = [
    const CompanyDashboardScreen(),
    const TransactionDetailScreen(true),
    const AppointmentCalendarScreen(),
    const UserProfileScreen(),
    const ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      body: appScreens[_pageIndex],
      // Container(
      //   child: appScreens.elementAt(_pageIndex),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_business_outlined), label: "Trxn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "User"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
      // BottomNav(
      //   // Navigation Bar widget
      //   selectedPage: _pageIndex,
      //   onDestinationSelected: (index) {
      //     setState(() {
      //       _pageIndex = index;
      //     });
      //   },
      // ),
    );
  }

  // Added this for BottomNavigationBar sync
  void setIndex(int index) {
    if (mounted) setState(() => _pageIndex = index);
  }
}
