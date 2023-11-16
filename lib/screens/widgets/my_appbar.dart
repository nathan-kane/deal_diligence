import 'package:flutter/material.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final auth = FirebaseAuth.instance; // Need this to logout

  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //automaticallyImplyLeading: false, // removes the back button in appbar
      title: const Text("Deal Diligence"),
      actions: [
        IconButton(
          onPressed: () {
            signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return AppBar(
  //     title: const Text("Deal Diligence"),
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           signOut();
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => LoginScreen()));
  //         },
  //         icon: const Icon(Icons.logout),
  //       )
  //     ],
  //   );
  // }
