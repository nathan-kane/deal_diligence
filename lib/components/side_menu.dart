import 'package:deal_diligence/screens/appointment_calendar.dart';
import 'package:deal_diligence/screens/chat_screen.dart';
import 'package:deal_diligence/screens/company_dash_board.dart';
import 'package:deal_diligence/screens/company_screen.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This is the video I used as a guide for this side menu
// https://www.youtube.com/watch?v=e7R5kx5wpBIhttps://www.youtube.com/watch?v=Z37ukFI4Ot0

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;
  final auth = FirebaseAuth.instance; // Need this to logout

  Future<void> signOut() async {
    await auth.signOut();
  }

  final List<Widget> appScreens = [
    const CompanyDashboardScreen(),
    const TransactionDetailScreen(true),
    const AppointmentCalendarScreen(),
    const CompanyScreen(),
    const UserProfileScreen(),
    const ChatScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Billy Bob Baker'),
            accountEmail: Text('billy.bob.baker@gmail.com'),
            //   currentAccountPicture: CircleAvatar(
            //     child: ClipOval(child: Image.asset('images/image.jpg')),
            //   ),
            //   decoration: const BoxDecoration(
            //     color: Colors.blueAccent,
            //   ),
          ),
          // ListTile(
          //   title: const Text('Home'),
          //   selected: selectedIndex == 0,
          //   onTap: () {
          //     // Update the state of the app
          //     onItemTapped(0);
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   title: const Text('New Transaction'),
          //   selected: selectedIndex == 1,
          //   onTap: () {
          //     // Update the state of the app
          //     onItemTapped(1);
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   title: const Text('Appointments'),
          //   selected: selectedIndex == 2,
          //   onTap: () {
          //     // Update the state of the app
          //     onItemTapped(2);
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            title: const Text('Add Company'),
            selected: selectedIndex == 3,
            onTap: () {
              // Update the state of the app
              onItemTapped(3);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Add User'),
            selected: selectedIndex == 4,
            onTap: () {
              // Update the state of the app
              onItemTapped(4);
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   title: const Text('Chat'),
          //   selected: selectedIndex == 5,
          //   onTap: () {
          //     // Update the state of the app
          //     onItemTapped(5);
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            title: const Text('Log Out'),
            selected: selectedIndex == 6,
            onTap: () {
              // Update the state of the app
              signOut();
              // Then close the drawer
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ],
      )),
    );
  }
}
