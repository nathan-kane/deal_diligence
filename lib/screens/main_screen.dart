//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/company_screen.dart';
import 'package:deal_diligence/screens/list_of_appraiser_companies.dart';
import 'package:deal_diligence/screens/list_of_inspector_companies.dart';
import 'package:deal_diligence/screens/list_of_mortgage_companies.dart';
import 'package:deal_diligence/screens/list_of_title_companies.dart';
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
import 'package:deal_diligence/screens/appraiser_company_screen.dart';
import 'package:deal_diligence/screens/inspector_profile_screen.dart';
import 'package:deal_diligence/screens/mortgage_company_screen.dart';
import 'package:deal_diligence/screens/title_company_screen.dart';

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

final auth = FirebaseAuth.instance;

String? userFName = "";
String? userLName = "";
String? userEmail = "";

Future<void> signOut() async {
  await auth.signOut();
}

class MainScreenState extends ConsumerState<MainScreen> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
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
      drawer: const SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: Colors.red),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
          if (value == 3) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const UserProfileScreen(false)));
            ref.read(globalsNotifierProvider.notifier).updatenewUser(false);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_business_outlined), label: "Trxn"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "User Profile"),
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

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("${userFName} ${userLName}"),
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
                leading: const Icon(
                  Icons.add_business,
                  color: Colors.blueAccent,
                ),
                title: const Text('Add RE Company'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompanyScreen(true)));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('Add Company Agent'),
                onTap: () {
                  Navigator.pop(context);
                  // ref
                  //     .read(globalsNotifierProvider.notifier)
                  //     .updateNewUser(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileScreen(true),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.account_balance,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('View Mortgage Companies'),
                onTap: () {
                  Navigator.pop(context);
                  // ref
                  //     .read(globalsNotifierProvider.notifier)
                  //     .updateNewUser(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ListOfMortgageCompaniesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_business,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('View Title Companies'),
                onTap: () {
                  Navigator.pop(context);
                  // ref
                  //     .read(globalsNotifierProvider.notifier)
                  //     .updateNewUser(true);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const TitleCompanyScreen(true),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListOfTitleCompaniesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_home,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('View Appraiser Companies'),
                onTap: () {
                  Navigator.pop(context);
                  // ref
                  //     .read(globalsNotifierProvider.notifier)
                  //     .updateNewUser(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ListOfAppraiserCompaniesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('View Inspector Companies'),
                onTap: () {
                  Navigator.pop(context);
                  // ref
                  //     .read(globalsNotifierProvider.notifier)
                  //     .updateNewUser(true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ListOfInspectorCompaniesScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calculate,
                  color: Colors.blueAccent,
                ),
                title: const Text('Mortgage Calculator'),
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
                leading: const Icon(
                  Icons.calculate,
                  color: Colors.blueAccent,
                ),
                title: const Text('Pricing'),
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
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text('Log Out'),
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
    );
  }
}
