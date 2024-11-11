//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:get/get.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/mortgage_company_screen.dart';
import 'package:flutter/foundation.dart';
//import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:deal_diligence/Providers/global_provider.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfMortgageCompaniesScreen extends ConsumerStatefulWidget {
  //static const String id = 'user_dashboard_screen';

  const ListOfMortgageCompaniesScreen({super.key});

  @override
  ConsumerState<ListOfMortgageCompaniesScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<ListOfMortgageCompaniesScreen> {
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
                future: FirebaseFirestore.instance
                    .collection('mortgageCompany')
                    .get(),
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
                                          '${snapshot.data?.docs[index]['mortgageCompanyName'] ?? 'n/a'}',
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
                                            '${snapshot.data?.docs[index]['mortgageCompanyState'] ?? 'n/a'}',
                                      ),
                                    ),
                                    trailing: Text(
                                        style: TextStyle(
                                            fontSize: tileBodyFontSize,
                                            fontWeight: FontWeight.bold),
                                        'Primary Contact: ${snapshot.data?.docs[index]['primaryContact'] ?? 'n/a'}'),
                                    onTap: () {
                                      //MainScreen.of(context)?.setIndex(2);  // Added this for BottomNavigationBar sync
                                      String? mortgageCompanyId =
                                          snapshot.data?.docs[index].id;
                                      //setGlobals(snapshot.data?.docs[index].id);
                                      // ref
                                      //     .read(globalsNotifierProvider.notifier)
                                      //     .updatecurrentTrxnId(
                                      //         snapshot.data?.docs[index].id);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MortgageCompanyScreen(
                                                  false, mortgageCompanyId),
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
                // ref.read(trxnNotifierProvider.notifier).saveTrxn(
                //     ref.read(trxnNotifierProvider),
                //     ref.read(globalsNotifierProvider).companyId!,
                //     widget.newTrxn!);
                // ref.read(globalsNotifierProvider.notifier).updatetargetScreen(0);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MortgageCompanyScreen(true),
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
