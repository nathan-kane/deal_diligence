//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:deal_diligence/screens/appraiser_company_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:deal_diligence/constants.dart' as constants;

final FirestoreService firestoreService = FirestoreService();

class ListOfAppraiserCompaniesScreen extends ConsumerStatefulWidget {
  //static const String id = 'user_dashboard_screen';

  const ListOfAppraiserCompaniesScreen({super.key});

  @override
  ConsumerState<ListOfAppraiserCompaniesScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<ListOfAppraiserCompaniesScreen> {
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
      tileTitleFontSize = 6.sp;
      tileBodyFontSize = 5.sp;
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
                    .collection('appraiserCompany')
                    .get(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data?.size,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.h),
                              child: Flexible(
                                child: ListTile(
                                  isThreeLine: true,
                                  title: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '${snapshot.data?.docs[index]['appraiserCompanyName'] ?? 'n/a'}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              //fontSize: tileTitleFontSize,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text.rich(
                                    TextSpan(
                                      style: TextStyle(fontSize: tileBodyFontSize),
                                      text:
                                          //'${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                          '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                          '${snapshot.data?.docs[index]['appraiserCompanyState'] ?? 'n/a'}',
                                    ),
                                  ),
                                  trailing: Text(
                                      style: TextStyle(
                                          fontSize: tileBodyFontSize,
                                          fontWeight: FontWeight.bold),
                                      'Primary Contact: ${snapshot.data?.docs[index]['primaryContact'] ?? 'n/a'}'),
                                  onTap: () {
                                    //MainScreen.of(context)?.setIndex(2);  // Added this for BottomNavigationBar sync
                                    String? appraiserCompanyId =
                                        snapshot.data?.docs[index].id;
                                    //setGlobals(snapshot.data?.docs[index].id);
                                    // ref
                                    //     .read(globalsNotifierProvider.notifier)
                                    //     .updatecurrentTrxnId(
                                    //         snapshot.data?.docs[index].id);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppraiserCompanyScreen(
                                                false, appraiserCompanyId),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const Text('No Data');
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
                    builder: (context) => const AppraiserCompanyScreen(true),
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
