//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                        *
//*********************************************

//import 'dart:async';

// ignore_for_file: non_constant_identifier_names

// import 'package:deal_diligence/Providers/title_company_provider.dart';
// import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:get/get.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
//import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/inspector_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfInspectorCompaniesScreen extends ConsumerStatefulWidget {
  //static const String id = 'user_dashboard_screen';

  const ListOfInspectorCompaniesScreen({super.key});

  @override
  ConsumerState<ListOfInspectorCompaniesScreen> createState() =>
      _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState
    extends ConsumerState<ListOfInspectorCompaniesScreen> {
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
                    .collection('inspectorCompany')
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
                                    Flexible(
                                      child: Text(
                                        '${snapshot.data?.docs[index]['inspectorCompanyName'] ?? 'n/a'}',
                                        style: const TextStyle(
                                            //fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    //style: TextStyle(
                                        //fontSize: 14.sp),
                                    text:
                                        //'${snapshot.data?.docs[index]['propertyAddress'] ?? 'n/a'}, '
                                        '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                        '${snapshot.data?.docs[index]['inspectorCompanyState'] ?? 'n/a'}',
                                  ),
                                ),
                                trailing: Text(
                                    style: const TextStyle(
                                        //fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    'Primary Contact: ${snapshot.data?.docs[index]['primaryContact'] ?? 'n/a'}'),
                                onTap: () {
                                  String? inspectorCompanyId =
                                      snapshot.data?.docs[index].id;

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          InspectorCompanyScreen(
                                              false, inspectorCompanyId),
                                    ),
                                  );
                                },
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
                    builder: (context) => const InspectorCompanyScreen(true),
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
