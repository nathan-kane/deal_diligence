import 'package:flutter/material.dart';
import 'package:deal_diligence/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key})
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
      backgroundColor: Colors.blue,
      //automaticallyImplyLeading: false, // removes the back button in appbar
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('lib/assets/images/dd_logo_72.png',
              fit: BoxFit.cover, height: 56),
        ],
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {
            signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }
}
