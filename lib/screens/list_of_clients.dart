//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/client_profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfClientsScreen extends ConsumerStatefulWidget {
  const ListOfClientsScreen({super.key});

  @override
  ConsumerState<ListOfClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ListOfClientsScreen> {
  bool showSpinner = false;
  bool isLoaded = false;

  ///
  /// Set the fonts sizes here because they don't seem to work
  /// with the responsive UI and List Tile widget
  ///
  double tileTitleFontSize = 14.sp;
  double tileBodyFontSize = 8.sp;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      tileTitleFontSize = 4.sp;
      tileBodyFontSize = 4.sp;
    } else {
      tileBodyFontSize = 14.sp;
      tileTitleFontSize = 10.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //appBar: CustomAppBar(),
          body: SafeArea(
            child: FutureBuilder<QuerySnapshot?>(
                future: FirebaseFirestore.instance.collection('client').get(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data?.size,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.h),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    isThreeLine: true,
                                    title: Row(
                                      children: [
                                        Text(
                                          'Client: ${snapshot.data?.docs[index]['fName'] ?? 'n/a'} ${snapshot.data?.docs[index]['lName'] ?? 'n/a'}',
                                          style: TextStyle(
                                              fontSize: tileTitleFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text.rich(
                                      TextSpan(
                                        style:
                                            TextStyle(fontSize: tileBodyFontSize),
                                        text:
                                            '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                            '${snapshot.data?.docs[index]['clientState'] ?? 'n/a'}',
                                      ),
                                    ),
                                    trailing: Text(
                                        style: TextStyle(
                                            fontSize: tileBodyFontSize,
                                            fontWeight: FontWeight.bold),
                                        'Cell Phone: ${snapshot.data?.docs[index]['cellPhone'] ?? 'n/a'}'),
                                    onTap: () {
                                      //MainScreen.of(context)?.setIndex(2);  // Added this for BottomNavigationBar sync
                                      String? clientId =
                                          snapshot.data?.docs[index].id;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClientProfileScreen(false, clientId),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Text('No Date');
                }),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            label: Text(
              "Add New",
              style: TextStyle(fontSize: constants.kTextButtonFontSize),
            ),
            icon: FaIcon(
              FontAwesomeIcons.plus,
              size: 6.sp,
            ),
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientProfileScreen(true),
                  ),
                );
                setState(() {
                  showSpinner = false;
                });
              } catch (e) {
                // todo: add better error handling
                //debugPrint(e);
              }
            },
          ),
        ),
      ),
    );
  }
}
