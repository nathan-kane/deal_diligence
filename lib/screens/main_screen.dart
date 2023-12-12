//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/company_screen.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:deal_diligence/screens/mortgage_calculator.dart';
import 'package:deal_diligence/screens/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:deal_diligence/screens/appointment_calendar.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:deal_diligence/screens/company_dash_board.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_diligence/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  // Added this for BottomNavigationBar sync
  // This allows the children to get the state of this page
  static MainScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainScreenState>();
  }

  @override
  //MainScreenState
  ConsumerState<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  final auth = FirebaseAuth.instance;
  int _pageIndex = 0;
  String? userFName = "";
  String? userLName = "";
  String? userEmail = "";

  @override
  void initState() {
    userFName = ref.read(usersNotifierProvider).fName;
    userLName = ref.read(usersNotifierProvider).lName;
    userEmail = ref.read(usersNotifierProvider).email;
  }

  final List<Widget> appScreens = [
    const CompanyDashboardScreen(),
    const TransactionDetailScreen(true),
    const AppointmentCalendarScreen(),
    const UserProfileScreen(),
    const ChatScreen(),
  ];

  Future<void> signOut() async {
    await auth.signOut();
  }

  // void onItemTapped(int index) {
  //   setState(() {
  //     _pageIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(child: appScreens[_pageIndex]),
      drawer: Drawer(
        child: (ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${userFName} ${userLName}"),
              //accountEmail: Text(userEmail!),
              accountEmail: Text(auth.currentUser!.email ?? 'No Email Found'),
              //   currentAccountPicture: CircleAvatar(
              //     child: ClipOval(child: Image.asset('images/image.jpg')),
              //   ),
              //   decoration: const BoxDecoration(
              //     color: Colors.blueAccent,
              //   ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add_business),
                  title: const Text('Add Company'),
                  //selected: _pageIndex == 5,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CompanyScreen(true)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Add User'),
                  //selected: _pageIndex == 6,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UserProfileScreen(true)));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Mortgage Calculator'),
                  //selected: _pageIndex == 6,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MortgageCalculatorScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  //selected: _pageIndex == 7,
                  onTap: () {
                    // Update the state of the app
                    signOut();
                    // Then close the drawer
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ],
        )),
      ),
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
          if (value == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(false)));
          }
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
    );
  }

  // Added this for BottomNavigationBar sync
  void setIndex(int index) {
    if (mounted) setState(() => _pageIndex = index);
  }
}
