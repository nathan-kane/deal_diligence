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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirestoreService firestoreService = FirestoreService();

class ListOfClientsScreen extends ConsumerStatefulWidget {
  const ListOfClientsScreen({super.key});

  @override
  ConsumerState<ListOfClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ListOfClientsScreen> {
  bool showSpinner = false;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              isThreeLine: true,
                              title: Row(
                                children: [
                                  Text(
                                    'Client: ${snapshot.data?.docs[index]['fName'] ?? 'n/a'} ${snapshot.data?.docs[index]['lName'] ?? 'n/a'}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              subtitle: Text.rich(
                                TextSpan(
                                  text:
                                      '${snapshot.data?.docs[index]['city'] ?? 'n/a'}, '
                                      '${snapshot.data?.docs[index]['clientState'] ?? 'n/a'}',
                                ),
                              ),
                              trailing: Text(
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
                          );
                        },
                      )
                    : const Text('No Date');
              }),
        ),
        floatingActionButton: FloatingActionButton(
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
          backgroundColor: constants.kPrimaryColor,
          child: const Icon(
            Icons.assignment_turned_in_outlined,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
