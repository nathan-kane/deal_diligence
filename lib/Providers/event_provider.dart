//import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deal_diligence/Services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deal_diligence/Providers/global_provider.dart';

class Events {
  String? id;
  String? eventName;
  DateTime? eventStartTime;
  String? eventDuration;
  DateTime? eventDate;
  String? eventDescription;
  String? userId;
  String? companyId;

  Events({
    this.id,
    this.eventName,
    this.eventStartTime,
    this.eventDuration,
    this.eventDate,
    this.eventDescription,
    this.userId,
    this.companyId,
  });

  // Reading data from firebase and converting it into Event type
  factory Events.fromJson(String id, Map<String, dynamic> doc) {
    //Map data = doc.data() as Map<String, dynamic>;
    return Events(
      id: id,
      eventName: doc['eventName'],
      eventStartTime: (doc['eventStartTime'] as Timestamp).toDate(),
      eventDuration: doc['eventDuration'],
      eventDate: (doc['eventDate'] as Timestamp).toDate(),
      eventDescription: doc['eventDescription'],
      userId: doc['userId'],
      companyId: doc['companyId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventStartTime': eventStartTime,
      'eventDuration': eventDuration,
      'eventDate': eventDate,
      'eventDescription': eventDescription,
      'agentId': userId,
      'agencyId': companyId,
    };
  }

  Events copyWith({
    String? eventName,
    DateTime? eventStartTime,
    String? eventDuration,
    DateTime? eventDate,
    String? eventDescription,
    String? userId,
    String? companyId,
  }) {
    return Events(
      eventName: eventName ?? this.eventName,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventDuration: eventDuration ?? this.eventDuration,
      eventDate: eventDate ?? this.eventDate,
      eventDescription: eventDescription ?? this.eventDescription,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
    );
  }
}

class EventsNotifier extends Notifier<Events> {
  final firestoreService = FirestoreService();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final eventRef = FirebaseFirestore.instance.collection(('events'));
  EventsNotifier();

  @override
  Events build() {
    return Events(
      // Return the initial state
      eventName: '',
      eventStartTime: DateTime.now(),
      eventDuration: '',
      eventDate: DateTime.now(),
      eventDescription: '',
      userId: '',
      companyId: '',
    );
  }

  String? eventName;
  DateTime? eventStartTime;
  String? eventDuration;
  DateTime? eventDate;
  String? eventDescription;
  String? userId;
  String? companyId;

  void updateEventname(String? newEventName) {
    state = state.copyWith(eventName: newEventName);
  }

  void updateeventStartTime(DateTime? newEventStartTime) {
    state = state.copyWith(eventStartTime: newEventStartTime);
  }

  void updateEventDuration(String? newEventDuration) {
    state = state.copyWith(eventDuration: newEventDuration);
  }

  void updateEventDate(DateTime? newEventDate) {
    state = state.copyWith(eventDate: newEventDate);
  }

  void updateEventDescription(String? newEventDescription) {
    state = state.copyWith(eventDescription: newEventDescription);
  }

  // pass in a map and get an object back
  EventsNotifier.fromFirestore(Map<String, dynamic> firestore)
      : eventName = firestore['eventName'],
        eventStartTime = firestore['eventStartTime'].toDate(),
        eventDuration = firestore['eventDuration'],
        eventDate = firestore['eventDate'].toDate(),
        eventDescription = firestore['eventDescription'],
        userId = firestore['agentId'],
        companyId = firestore['agencyId'];

  saveEvent(Events events, String? eventDesc, [String? eventId]) {
    var newEvent = Events(
        eventName: events.eventName,
        eventStartTime: events.eventStartTime,
        eventDuration: events.eventDuration,
        eventDate: events.eventDate,
        eventDescription: "rrrrr", //events.eventDescription,
        companyId: ref.read(globalsNotifierProvider).companyId,
        userId: ref.read(globalsNotifierProvider).currentUserId);

    if (eventId != null && eventId != '') {
      firestoreService.saveEvent(
          newEvent, ref, eventId); // Update existing event
      ref.read(globalsNotifierProvider.notifier).updatenewEvent(false);
    } else {
      firestoreService.saveEvent(newEvent, ref); // Create new event
    }
  }

  deleteEvent(String? eventId) {
    firestoreService.deleteEvent(eventId, ref);
  }
}

final eventsNotifierProvider = NotifierProvider<EventsNotifier, Events>(() {
  return EventsNotifier();
});
