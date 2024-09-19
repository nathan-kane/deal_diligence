//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

//import 'package:flutter/material.dart';
//import 'package:add_2_calendar/add_2_calendar.dart';
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
  String? location;
  late bool allDay;
  String? userId;
  String? companyId;
  String? frequency;
  int? occurrences;
  DateTime? recurrenceEndDate;
  int interval = 1;
  String? rRule;

  Events({
    this.id,
    this.eventName,
    this.eventStartTime,
    this.eventDuration,
    this.eventDate,
    this.eventDescription,
    this.location,
    this.allDay = false,
    this.userId,
    this.companyId,
    this.frequency,
    this.occurrences,
    this.recurrenceEndDate,
    this.interval = 1,
    this.rRule,
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
      location: doc['location'],
      allDay: doc['allDay'],
      userId: doc['userId'],
      companyId: doc['companyId'],
      frequency: doc['frequency'],
      occurrences: doc['occurences'],
      recurrenceEndDate: (doc['recurrenceEndDate'] as Timestamp).toDate(),
      interval: doc['interval'],
      rRule: doc['rRule'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventStartTime': eventStartTime,
      'eventDuration': eventDuration,
      'eventDate': eventDate,
      'eventDescription': eventDescription,
      'location': location,
      'allDay': allDay,
      'agentId': userId,
      'agencyId': companyId,
      'frequency': frequency,
      'occurences': occurrences,
      'recurrenceEndDate': recurrenceEndDate,
      'interval': interval,
      'rRule': rRule,
    };
  }

  Events copyWith({
    String? eventName,
    DateTime? eventStartTime,
    String? eventDuration,
    DateTime? eventDate,
    String? eventDescription,
    String? location,
    bool allday = false,
    String? userId,
    String? companyId,
    String? frequency,
    int? occurences,
    DateTime? recurrenceEndDate,
    int interval = 1,
    String? rRule,
  }) {
    return Events(
      eventName: eventName ?? this.eventName,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventDuration: eventDuration ?? this.eventDuration,
      eventDate: eventDate ?? this.eventDate,
      eventDescription: eventDescription ?? this.eventDescription,
      location: location ?? this.location,
      allDay: allDay,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      frequency: frequency ?? this.frequency,
      occurrences: occurences ?? this.occurrences,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      interval: interval,
      rRule: rRule ?? this.rRule,
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
      location: '',
      allDay: false,
      userId: '',
      companyId: '',
      frequency: '',
      occurrences: 1,
      recurrenceEndDate: DateTime.now(),
      interval: 1,
      rRule: '',
    );
  }

  String? eventName;
  DateTime? eventStartTime;
  String? eventDuration;
  DateTime? eventDate;
  String? eventDescription;
  String? location;
  late bool allDay;
  String? userId;
  String? companyId;
  String? frequency;
  int? occurences;
  DateTime? recurrenceEndDate;
  int interval = 1;
  String? rRule;

  void updateEventName(String? newEventName) {
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

  void updateLocation(String? newLocation) {
    state = state.copyWith(location: newLocation);
  }

  void updateAllDay(bool newAllDay) {
    state = state.copyWith(allday: newAllDay);
  }

  void updateFrequency(String? newFrequency) {
    state = state.copyWith(frequency: newFrequency);
  }

  void updateOccurrences(int? newOccurences) {
    state = state.copyWith(occurences: newOccurences);
  }

  void updateRecurrenceEndDate(DateTime? newRecurrenceEndDate) {
    state = state.copyWith(recurrenceEndDate: newRecurrenceEndDate);
  }

  void updateInterval(int newInterval) {
    state = state.copyWith(interval: newInterval);
  }

  void updateRRule(String? newRRule) {
    state = state.copyWith(rRule: newRRule);
  }

  // pass in a map and get an object back
  EventsNotifier.fromFirestore(Map<String, dynamic> firestore)
      : eventName = firestore['eventName'],
        eventStartTime = firestore['eventStartTime'].toDate(),
        eventDuration = firestore['eventDuration'],
        eventDate = firestore['eventDate'].toDate(),
        eventDescription = firestore['eventDescription'],
        location = firestore['location'],
        allDay = firestore['allDay'],
        userId = firestore['agentId'],
        companyId = firestore['agencyId'],
        frequency = firestore['frequency'],
        occurences = firestore['occurences'],
        recurrenceEndDate = firestore['recurrenceEndDate'],
        interval = firestore['interval'],
        rRule = firestore['rRule'];

  saveEvent(Events events, String? eventDesc, [String? eventId]) {
    var newEvent = Events(
        eventName: events.eventName,
        eventStartTime: events.eventStartTime,
        eventDuration: events.eventDuration,
        eventDate: events.eventDate,
        eventDescription: events.eventDescription,
        location: events.location,
        allDay: events.allDay,
        companyId: ref.read(globalsNotifierProvider).companyId,
        userId: ref.read(globalsNotifierProvider).currentUserId,
        frequency: events.frequency,
        occurrences: events.occurrences,
        recurrenceEndDate: events.recurrenceEndDate,
        rRule: events.rRule);

    if (eventId != null && eventId != '') {
      firestoreService.saveEvent(
          newEvent, ref, eventId); // Update existing event
      ref.read(globalsNotifierProvider.notifier).updateNewEvent(false);
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
