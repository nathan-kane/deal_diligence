//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:deal_diligence/Services/firestore_service.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:intl/intl.dart';
//import 'package:deal_diligence/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:deal_diligence/screens/main_screen.dart';
//import 'package:provider/provider.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
//import 'package:deal_diligence/Models/Events.dart';
import 'package:deal_diligence/screens/appointment_calendar.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String? currentEventId = "";

class AddEventScreen extends ConsumerStatefulWidget {
  //static const String id = 'add_event_screen';
  //Events? event;
  String? eventDocId;

  AddEventScreen({super.key, this.eventDocId});

  @override
  ConsumerState<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends ConsumerState<AddEventScreen> {
  //final _db = FirebaseFirestore.instance;

  final eventNameController = TextEditingController();
  final eventStartTimeController = TextEditingController();
  final eventDurationController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventDescriptionController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    eventStartTimeController.dispose();
    eventDurationController.dispose();
    eventDateController.dispose();
    eventDescriptionController.dispose();

    super.dispose();
  }

  bool showSpinner = false;
  String? eventName;
  String? eventStartTime;
  String? eventDuration;
  String? eventDate;
  String? eventDescription;

  getCurrentCompanyEvents() async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(globalsNotifierProvider).currentUserId)
        .collection('event');

    if (currentEventId == null) {
      eventNameController.text = "";
      eventStartTimeController.text = "";
      eventDurationController.text = "";
      eventDateController.text = "";
      eventDescriptionController.text = "";
    } else {
      final DocumentSnapshot currentEvent =
          await eventRef.doc(widget.eventDocId).get();

      // existing record
      // Updates Controllers
      eventNameController.text = currentEvent.get("eventName");
      eventStartTimeController.text = DateFormat('h:mm a').format(
          currentEvent['eventStartTime']
              .toDate()); //currentEvent.get('eventStartTime').toString();
      eventDurationController.text = currentEvent.get('eventDuration');
      eventDateController.text = DateFormat('EE,  MM-dd-yyyy')
          .format(currentEvent['eventDate'].toDate());
      eventDescriptionController.text = currentEvent.get('eventDescription');

      // Updates State
      // Future.delayed(Duration.zero, () {
      //   final eventProvider =
      //   Provider.of<EventProvider>(context, listen: false);
      //   eventProvider.loadValues(widget.event!);
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    currentEventId = widget.eventDocId;
    getCurrentCompanyEvents();
  }

  @override
  Widget build(BuildContext context) {
    //final eventRead = ref.read(globalsNotifierProvider);
    //final _firestoreService = FirestoreService();
    DateTime _date = DateTime.now();
    //String _time = TimeOfDay.now().toString();
    //Duration initialtimer = const Duration();
    DateTime _selectedDate = DateTime.now();
    DateTime _dt = DateTime.now();
    //String _timePicked = TimeOfDay.now().toString();

    //DateFormat dateFormat = DateFormat("h:mm a");

    return Scaffold(
      //appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Event Editor',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: eventNameController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateEventname(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Event Name', labelText: 'Event Name'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventDurationController,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateEventDuration(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Duration', labelText: 'Duration'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventDateController,
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _datePicked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2026));
                    if (_date != _datePicked) {
                      setState(() {
                        eventDateController.text =
                            DateFormat("MM/dd/yyyy").format(_datePicked!);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDate(_datePicked);
                        _selectedDate = _datePicked;
                        //DateFormat("MM/dd/yyyy").format(_date));
                      });
                    }
                  },
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateEventDate(_date);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Date',
                    labelText: 'Date',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventStartTimeController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    final TimeOfDay? _timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_timePicked != null) {
                      _dt = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );
                      setState(() {
                        eventStartTimeController.text =
                            DateFormat('h:mm a').format(_dt);
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateeventStartTime(_dt);
                      });
                    }
                  },
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateeventStartTime(_dt);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start Time',
                    labelText: 'Start Time',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventDescriptionController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    // ref
                    //     .read(eventsNotifierProvider.notifier)
                    //     .updateEventDescription(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Description', labelText: 'Description'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RoundedButton(
                  title: 'Save Event',
                  colour: Colors.blueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatenewEvent(true);
                      if (currentEventId != null && currentEventId != '') {
                        ref.read(eventsNotifierProvider.notifier).saveEvent(
                            ref.read(eventsNotifierProvider), currentEventId);
                      } else {
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(
                                eventDescriptionController.text);

                        ref.read(eventsNotifierProvider.notifier).saveEvent(
                            ref.read(eventsNotifierProvider),
                            eventDescriptionController
                                .text); // Create new event
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const AppointmentCalendarScreen()));

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //print(e);
                    }
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                (widget != null)
                    ? RoundedButton(
                        title: 'Delete',
                        colour: Colors.red,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            ref
                                .read(eventsNotifierProvider.notifier)
                                .deleteEvent(currentEventId);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AppointmentCalendarScreen()));

                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            // todo: add better error handling
                            //print(e);
                          }
                        },
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
