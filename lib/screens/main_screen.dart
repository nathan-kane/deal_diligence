//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:deal_diligence/screens/company_screen.dart';
import 'package:deal_diligence/screens/list_of_appraiser_companies.dart';
import 'package:deal_diligence/screens/list_of_clients.dart';
import 'package:deal_diligence/screens/list_of_inspector_companies.dart';
import 'package:deal_diligence/screens/list_of_mortgage_companies.dart';
import 'package:deal_diligence/screens/list_of_title_companies.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:deal_diligence/screens/mortgage_calculator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:deal_diligence/screens/privacy_policy_screen.dart';
//import 'package:deal_diligence/screens/property_webview_screen.dart';
import 'package:deal_diligence/screens/widgets/my_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:deal_diligence/screens/appointment_calendar.dart';
import 'package:deal_diligence/screens/transaction_detail_screen.dart';
import 'package:deal_diligence/screens/user_profile_screen.dart';
import 'package:deal_diligence/screens/list_of_trxns.dart';
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

final auth = FirebaseAuth.instance;

String? userFName = "";
String? userLName = "";
String? userEmail = "";

final Uri _privacyURI =
    Uri.parse('https://dealdiligencecentral.com/privacy_policy.html');

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
    const TransactionDetailScreen(true, true),
    ///const AppointmentCalendarScreen(),
    const UserProfileScreen(),
    const ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(child: Container(child: appScreens[_pageIndex])),
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
                ref.read(globalsNotifierProvider.notifier).updatenewUser(false);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const UserProfileScreen(false)));
              }
            },

            ///
            /// Bottom Navigation Bar items
            ///
            items: const [
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.fileInvoiceDollar),
                  label: "Trxn"),
              // BottomNavigationBarItem(
              //     icon: FaIcon(FontAwesomeIcons.calendar), label: "Calendar"),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.person), label: "User Profile"),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            ],
          ),
        ),
      ),
    );
  }

  // Added this for BottomNavigationBar sync
  void setIndex(int index) {
    if (mounted) setState(() => _pageIndex = index);
  }
}

///
/// Side drawer menu items
///
class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("$userFName $userLName"),
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
                //title: const Text('Add RE Company'),
                title: const Text('Edit Company'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CompanyScreen(false)));
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.person,
              //     color: Colors.lightBlueAccent,
              //   ),
              //   title: const Text('Add Company Agent'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // ref
              //     //     .read(globalsNotifierProvider.notifier)
              //     //     .updateNewUser(true);
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const UserProfileScreen(true),
              //       ),
              //     );
              //   },
              // ),
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
                  Icons.person_outline_sharp,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text('View Clients'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListOfClientsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.businessTime),
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
                leading: const FaIcon(FontAwesomeIcons.personWalking),
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
                leading: const FaIcon(FontAwesomeIcons.peopleCarryBox),
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
                leading: const FaIcon(FontAwesomeIcons.calculator),
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
              // ListTile(
              //   leading: const FaIcon(FontAwesomeIcons.dollarSign),
              //   title: const Text('Pricing'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 const MortgageCalculatorScreen()));
              //   },
              // ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.lock),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
                onTap: () {
                  if (kIsWeb) {
                    _launchInBrowser();
                    //launchUrl(uri.parse('https://dealdiligencecentral.com/privacy_policy.html'));
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()));
                  }
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

  Future<void> _launchInBrowser() async {
    if (!await launchUrl(_privacyURI)) {
      throw Exception('Could not launch $_privacyURI');
    }
  }
}
