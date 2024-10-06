//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
//import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/components/styles.dart';
import 'package:deal_diligence/components/widgets.dart';
//import 'package:deal_diligence/Providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:deal_diligence/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:deal_diligence/screens/widgets/my_appbar.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  var roomId;

  // void setUpPushNotifcations() {
  //   // TODO(any): Push notifications do not currently work on Safari iOS (see: https://caniuse.com/push-api). Implement this feature some other way.
  // }

  // void setUpPushNotifications() async {
  //   final fcm = FirebaseMessaging.instance;

  //   await fcm.requestPermission();
  //   fcm.subscribeToTopic('chat');
  // }

  @override
  void initState() {
    super.initState();

    // setUpPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.indigo.shade400,
      //appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chats',
                    style: Styles.h1(),
                  ),
                  const Spacer(),
                  StreamBuilder(
                      stream: firestore
                          .collection('users')
                          .doc(ref.read(globalsNotifierProvider).currentUid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        return !snapshot.hasData
                            ? Container()
                            : Text(
                                'Last seen : ${DateFormat('hh:mm a').format(
                                    /*snapshot
                                        .data!['datetime']
                                        .toDate()*/
                                    DateTime.now())}',
                                style: Styles.h1().copyWith(
                                    fontSize: 6.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white70),
                              );
                      }),
                  const Spacer(),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: Styles.friendsBox(),
                child: StreamBuilder(
                    stream: firestore.collection('Rooms').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          List<QueryDocumentSnapshot?> allData = snapshot
                              .data!.docs
                              .where((element) =>
                                  element['users'].contains(ref
                                      .read(globalsNotifierProvider)
                                      .currentUid) &&
                                  element['users'].contains(
                                      FirebaseAuth.instance.currentUser!.uid))
                              .toList();
                          QueryDocumentSnapshot? data =
                              allData.isNotEmpty ? allData.first : null;
                          if (data != null) {
                            roomId = data.id;
                          }
                          return data == null
                              ? Container()
                              : StreamBuilder(
                                  stream: data.reference
                                      .collection('messages')
                                      .orderBy('datetime', descending: true)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snap) {
                                    return !snap.hasData
                                        ? Container()
                                        : ListView.builder(
                                            itemCount: snap.data!.docs.length,
                                            reverse: true,
                                            itemBuilder: (context, i) {
                                              return ChatWidgets.messagesCard(
                                                  snap.data!.docs[i]['sent_by'] ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                  snap.data!.docs[i]['message'],
                                                  DateFormat('hh:mm a').format(
                                                      snap.data!
                                                          .docs[i]['datetime']
                                                          .toDate()));
                                            },
                                          );
                                  });
                        } else {
                          return Center(
                            child: Text(
                              'No conversion found',
                              style: Styles.h1()
                                  .copyWith(color: Colors.indigo.shade400),
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.indigo,
                          ),
                        );
                      }
                    }),
              ),
            ),
            Container(
              color: Colors.white,
              child: ChatWidgets.messageField(onSubmit: (controller) {
                if (controller.text.toString() != '') {
                  if (roomId != null) {
                    Map<String, dynamic> data = {
                      'message': controller.text.trim(),
                      'sent_by': FirebaseAuth.instance.currentUser!.uid,
                      'datetime': DateTime.now(),
                    };
                    firestore.collection('Rooms').doc(roomId).update({
                      'last_message_time': DateTime.now(),
                      'last_message': controller.text,
                    });
                    firestore
                        .collection('Rooms')
                        .doc(roomId)
                        .collection('messages')
                        .add(data);
                  } else {
                    Map<String, dynamic> data = {
                      'message': controller.text.trim(),
                      'sent_by': FirebaseAuth.instance.currentUser!.uid,
                      'datetime': DateTime.now(),
                    };
                    firestore.collection('Rooms').add({
                      'users': [
                        ref.read(globalsNotifierProvider).currentUid,
                        FirebaseAuth.instance.currentUser!.uid,
                      ],
                      'last_message': controller.text,
                      'last_message_time': DateTime.now(),
                    }).then((value) async {
                      value.collection('messages').add(data);
                    });
                  }
                }
                controller.clear();
              }),
            )
          ],
        ),
      ),
    );
  }
}
