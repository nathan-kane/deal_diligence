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
//import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/mortgage_company_screen.dart';
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

  // setGlobals(String? Id) {
  //   ref.read(globalsNotifierProvider.notifier).updatenewTrxn(false);
  //   ref.read(globalsNotifierProvider.notifier).updatecurrentTrxnId(Id);
  //   ref
  //       .read(globalsNotifierProvider.notifier)
  //       .updatemlsId(ref.read(usersNotifierProvider).mlsId!);
  // }

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
                              padding: EdgeInsets.symmetric(horizontal: 50.sp),
                              child: ListTile(
                                isThreeLine: true,
                                title: Row(
                                  children: [
                                    Text(
                                      '${snapshot.data?.docs[index]['mortgageCompanyName'] ?? 'n/a'}',
                                      style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                        fontSize: 5.sp),
                                    text:
                                        //'${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                        '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                        '${snapshot.data?.docs[index]['mortgageCompanyState'] ?? 'n/a'}',
                                  ),
                                ),
                                trailing: Text(
                                    style: TextStyle(
                                        fontSize: 5.sp,
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
              style: TextStyle(fontSize: ScreenUtil().setSp(6.r)),
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
