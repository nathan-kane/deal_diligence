//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

//import 'dart:async';
//import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/components/rounded_button.dart';
import 'package:deal_diligence/constants.dart' as constants;
import 'package:deal_diligence/screens/appointment_calendar.dart';
//import 'package:deal_diligence/screens/google_event_add.dart';
import 'package:deal_diligence/screens/widgets/add_all_calendars.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

String? currentEventId = "";
DateTime kNow = DateTime.now();

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
  var calendarInstance = AddEventsToAllCalendars();

  final eventNameController = TextEditingController();
  final eventStartTimeController = TextEditingController();
  final eventDurationController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventLocationController = TextEditingController();
  final eventOccurencesController = TextEditingController();
  final eventIntervalController = TextEditingController();
  final eventRecurrenceEndDateController = TextEditingController();
  String? selectedFrequency = 'Select';
  String? _currentFrequency = 'Select';

  @override
  void dispose() {
    eventNameController.dispose();
    eventStartTimeController.dispose();
    eventDurationController.dispose();
    eventDateController.dispose();
    eventDescriptionController.dispose();
    eventOccurencesController.dispose();
    eventIntervalController.dispose();
    eventRecurrenceEndDateController.dispose();

    super.dispose();
  }

  bool showSpinner = false;
  String? eventName;
  String? eventStartTime;
  String? eventDuration;
  DateTime? eventDate;
  String? eventDescription;
  bool isAllDay = false;
  DateTime eventStartDate = DateTime.now();
  DateTime recurrenceEndDate = DateTime.now();

  getCurrentCompanyEvents() async {
    final eventRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(globalsNotifierProvider).currentUserId)
        .collection('event');

    if (currentEventId == null) {
      // New event
      eventNameController.text = "";
      eventStartTimeController.text = "";
      eventDurationController.text = "";
      eventDateController.text = "";
      eventDescriptionController.text = "";
    } else {
      // Existing event
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
      _currentFrequency = currentEvent.get('frequency');
      isAllDay = currentEvent.get('allDay');

      // Updates State
      // Future.delayed(Duration.zero, () {
      //   final eventProvider =
      //   Provider.of<EventProvider>(context, listen: false);
      //   eventProvider.loadValues(widget.event!);
      // });
    }
  }

  void changedDropDownFrequency(String? selectedFrequency) {
    setState(() {
      _currentFrequency = selectedFrequency;
      ref
          .read(eventsNotifierProvider.notifier)
          .updateFrequency(selectedFrequency!);
    });
  }

  List<DropdownMenuItem<String>>? dropDownFrequency;

  List<DropdownMenuItem<String>> getDropDownFrequency() {
    List<DropdownMenuItem<String>> items = [];
    for (String state in constants.kFrequencyList) {
      items.add(DropdownMenuItem(
          value: state,
          child: Text(
            state,
          )));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    if (widget.eventDocId == null || widget.eventDocId == "") {
      _currentFrequency = 'Select';
    }
    currentEventId = widget.eventDocId;
    getCurrentCompanyEvents();
    dropDownFrequency = getDropDownFrequency();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.now();
    DateTime _selectedDate = DateTime.now();
    DateTime _selectedRecurrenceDate = DateTime.now();
    //DateTime _dt = DateTime.now();

    //AddEventsToAllCalendars addEventsToAllCalendars = AddEventsToAllCalendars();
    bool isChecked = true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Event',
                  style: TextStyle(
                    fontSize: 20,
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
                      hintText: 'Event Name*', labelText: 'Event Name*'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventDateController,
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _eventDatePicked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate:
                            DateTime(kNow.year, kNow.month - 3, kNow.day),
                        lastDate:
                            DateTime(kNow.year, kNow.month + 36, kNow.day));
                    if (_date != _eventDatePicked) {
                      // Save the Date picked to the eventStartDate variable
                      eventDate = DateTime(_eventDatePicked!.year,
                          _eventDatePicked.month, _eventDatePicked.day);
                      // ref
                      //     .read(eventsNotifierProvider.notifier)
                      //     .updateEventDate(eventStartDate);
                      setState(() {
                        eventDateController.text =
                            DateFormat("MM/dd/yyyy").format(_eventDatePicked);

                        _selectedDate = _eventDatePicked;
                        //DateFormat("MM/dd/yyyy").format(_date));
                      });
                    }
                  },
                  onChanged: (value) {
                    //eventStartDate = DateTime.parse(eventDateController.text);
                    // ref
                    //     .read(eventsNotifierProvider.notifier)
                    //     .updateEventDate(DateTime.parse(value));
                  },
                  decoration: const InputDecoration(
                    hintText: 'Event Date*',
                    labelText: 'Event Date*',
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
                      // DateTime eventDate =
                      //     ref.read(eventsNotifierProvider).eventDate!;

                      // Add the selected time to the eventStartDate variable
                      eventStartDate = DateTime(
                        eventDate!.year,
                        eventDate!.month,
                        eventDate!.day,
                        _timePicked.hour,
                        _timePicked.minute,
                      );

                      // Set eventDate to have the full date and time of the event
                      eventDate = eventStartDate;
                      ref
                          .read(eventsNotifierProvider.notifier)
                          .updateEventDate(eventDate);
                      // _dt = DateTime(
                      //   eventDate.year,
                      //   eventDate.month,
                      //   eventDate.day,
                      //   _timePicked.hour,
                      //   _timePicked.minute,
                      // );
                      setState(() {
                        eventStartTimeController.text =
                            DateFormat('h:mm a').format(eventStartDate);
                        // ref
                        //     .read(eventsNotifierProvider.notifier)
                        //     .updateeventStartTime(
                        //         DateTime.parse(eventStartTimeController.text));
                      });
                    }
                  },
                  onChanged: (value) {
                    // ref
                    //     .read(eventsNotifierProvider.notifier)
                    //     .updateeventStartTime(_dt);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start Time*',
                    labelText: 'Start Time*',
                  ),
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
                      hintText: 'Duration (mins)*',
                      labelText: 'Duration (mins)*'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: eventDescriptionController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      hintText: 'Description', labelText: 'Description'),
                ),
                const SizedBox(
                  height: 8.0,
                ),

                TextField(
                  controller: eventLocationController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateLocation(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'Location', labelText: 'Location'),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  '---- RECURRING EVENT ----',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropdownButton<String>(
                  hint: const Text('Select Frequency'),
                  value: _currentFrequency,
                  onChanged: (_value) {
                    setState(() {
                      selectedFrequency = _value;
                      _currentFrequency = selectedFrequency;
                      ref
                          .read(eventsNotifierProvider.notifier)
                          .updateFrequency(_value);
                    });
                  },
                  items: <String>[
                    'Select',
                    'daily',
                    'weekly',
                    'monthly',
                    'yearly'
                  ].map<DropdownMenuItem<String>>((String _value) {
                    return DropdownMenuItem<String>(
                      value: _value,
                      child: Text(_value),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: eventOccurencesController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateOccurences(int.parse(value));
                  },
                  decoration: const InputDecoration(
                      hintText: 'Occurences', labelText: 'Occurences'),
                ),
                TextField(
                  controller: eventRecurrenceEndDateController,
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  onTap: () async {
                    DateTime? _dateRecurrencePicked = await showDatePicker(
                        context: context,
                        initialDate: _selectedRecurrenceDate,
                        firstDate:
                            DateTime(kNow.year, kNow.month - 3, kNow.day),
                        lastDate:
                            DateTime(kNow.year, kNow.month + 36, kNow.day));
                    if (_date != _dateRecurrencePicked) {
                      // Save the Date picked to recurrenceEndDate variable
                      recurrenceEndDate = DateTime(
                          _dateRecurrencePicked!.year,
                          _dateRecurrencePicked.month,
                          _dateRecurrencePicked.day);

                      ref
                          .read(eventsNotifierProvider.notifier)
                          .updateRecurrenceEndDate(recurrenceEndDate);
                      setState(() {
                        eventRecurrenceEndDateController.text =
                            DateFormat("MM/dd/yyyy")
                                .format(_dateRecurrencePicked);

                        _selectedRecurrenceDate = _dateRecurrencePicked;
                        //DateFormat("MM/dd/yyyy").format(_date));
                      });
                    }
                  },
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Recurrence End Date',
                    labelText: 'Recurrence End Date',
                  ),
                ),
                TextField(
                  controller: eventIntervalController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    ref
                        .read(eventsNotifierProvider.notifier)
                        .updateInterval(int.parse(value));
                  },
                  decoration: const InputDecoration(
                      hintText: 'Interval', labelText: 'Interval'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'All day event? ',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Checkbox(
                          value: isAllDay,
                          onChanged: (bool? value) {
                            setState(() {
                              isAllDay = value!;
                              ref
                                  .read(eventsNotifierProvider.notifier)
                                  .updateAllDay(isAllDay);
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),

                // Save the event to the user's Google calendar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Save to Google calendar? ',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                      ),
                    )
                  ],
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
                      /// Save event date and end of recurrence date to state
                      ref
                          .read(eventsNotifierProvider.notifier)
                          .updateEventDate(eventStartDate);
                      ref
                          .read(eventsNotifierProvider.notifier)
                          .updateRecurrenceEndDate(recurrenceEndDate);
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updatenewEvent(true);

                      // /// Save the event to the db document
                      if (currentEventId != null && currentEventId != '') {
                        ref.read(eventsNotifierProvider.notifier).saveEvent(
                            ref.read(eventsNotifierProvider), currentEventId);
                      } else {
                        /// This is a new event
                        ref
                            .read(eventsNotifierProvider.notifier)
                            .updateEventDescription(
                                eventDescriptionController.text);
                                
                        /// Save the new event to the db document
                        ref.read(eventsNotifierProvider.notifier).saveEvent(
                            ref.read(eventsNotifierProvider),
                            eventDescriptionController
                                .text); // Create new event
                      }
                      if (isChecked) {
                        // DateTime endTime = ref
                        // .read(eventsNotifierProvider)
                        // .eventStartTime!
                        // .add(Duration(
                        //     minutes:
                        //         int.parse(eventDurationController.text)));

                        AddEventsToAllCalendars().addEvent2(
                            ref.read(eventsNotifierProvider));

                                                    // AddEventsToAllCalendars().addEvent2();
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const AppointmentCalendarScreen()));

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      // todo: add better error handling
                      //debugPrint(e);
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
                            //debugPrint(e);
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
