//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

// ignore_for_file: unused_element, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers, dead_code

import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:deal_diligence/Providers/global_provider.dart';
import 'package:deal_diligence/Providers/trxn_provider.dart';
import 'package:deal_diligence/screens/add_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 12, kNow.day);
List<Events> events = [];

final _db = FirebaseFirestore.instance;

bool showSpinner = false;
DateTime? _selectedDay;
DateTime _focusedDay = DateTime.now();
LinkedHashMap<DateTime, List<Events>> kEvents =
    LinkedHashMap<DateTime, List<Events>>();

class AppointmentCalendarScreen extends ConsumerStatefulWidget {
  const AppointmentCalendarScreen({super.key, this.title});

  final String? title;

  @override
  ConsumerState<AppointmentCalendarScreen> createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState
    extends ConsumerState<AppointmentCalendarScreen>
    with TickerProviderStateMixin {
  //late final List<Events> _selectedEvents;
  //final CalendarFormat _calendarFormat = CalendarFormat.month;
  //RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  //DateTime? _rangeStart;
  //DateTime? _rangeEnd;

  late StreamController<Map<DateTime, List>> _streamController;
  var eventDoc;
  var trxnDoc;
  Map<DateTime, List>? eventsMap;

  @override
  void initState() {
    super.initState();

    _streamController = StreamController();
    _selectedDay = _focusedDay;

    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!, events));
  }

  @override
  void dispose() {
    //_selectedEvents.dispose();
    _streamController.close();

    super.dispose();
  }

  // List<Events>? _getTrxnEventsForDay(DateTime day, List<Trxn>? trxns) {
  //   DateTime? trxnDate;
  //   DateTime trxnDateUTC;

  //   for (int i = 0; i < trxnDoc.length; i++) {
  //     if (trxnDoc[i].contractDate != null && trxnDoc[i].contractDate != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].contractDate);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].contractDate);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].closingDate != null && trxnDoc[i].closingDate != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].closingDate);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].closingDate);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].dueDiligence24b != null &&
  //         trxnDoc[i].dueDiligence24b != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].dueDiligence24b);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].dueDiligence24b);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].financing24c != null && trxnDoc[i].financing24c != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].financing24c);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].financing24c);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].inspectionDate != null &&
  //         trxnDoc[i].inspectionDate != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].inspectionDate);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc['inspectionDate']);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].appraisalDate != null && trxnDoc[i].appraisalDate != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].appraisalDate);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].appraisalDate);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].sellerDisclosure24a != null &&
  //         trxnDoc[i].sellerDisclosure24a != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].sellerDisclosure24a);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].sellerDisclosure24a);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }

  //     if (trxnDoc[i].walkThroughDate != null &&
  //         trxnDoc[i].walkThroughDate != "") {
  //       trxnDate = DateTime.tryParse(trxnDoc[i].walkThroughDate);
  //       trxnDateUTC = trxnDate!.toUtc();
  //       if (day.year == trxnDate.year &&
  //           day.day == trxnDate.day &&
  //           day.month == trxnDate.month) {
  //         List<Events> eventList = [];
  //         eventList.add(trxnDoc[i].walkThroughDate);
  //         (kEvents.putIfAbsent(trxnDateUTC, () => eventList));
  //       }
  //     }
  //     //eventList.add(trxnDoc[i]);
  //     //(kEvents.putIfAbsent(trxnDateUTC, () => eventList))??[];
  //   }

  //   return [];
  // }

  List<Events> _getEventsForDay(DateTime day, List<Events>? events) {
    List<Events> listDayEvents = [];

    if (events == null) {
      return listDayEvents; // Return an empty list if events is null
    }

    for (Events event in events) {
      if (event.eventDate != null &&
          day.year == event.eventDate!.year &&
          day.month == event.eventDate!.month &&
          day.day == event.eventDate!.day) {
        listDayEvents.add(event);
      }
    }
    return listDayEvents;
  }

  // List<Events> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay,
      [List<Events>? events]) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        //_rangeStart = null; // Important to clean those
        //_rangeEnd = null;
        //_rangeSelectionMode = RangeSelectionMode.toggledOff;
      });
      //_selectedEvents = _getEventsForDay(selectedDay, events);
    }
    //_buildEventList();
  }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });

  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedEvents.value = _getEventsForRange(start, end);
  //   } else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end, events);
  //   }
  // }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: CustomAppBar(),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                // Get all the events starting from current month - 3
                // to current month + 12
                stream: _db
                    .collection('users')
                    .doc(ref.read(globalsNotifierProvider).currentUserId)
                    .collection('events')
                    .where('eventDate', isGreaterThanOrEqualTo: kFirstDay)
                    .where('eventDate', isLessThanOrEqualTo: kLastDay)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // Handle any errors
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data: ${snapshot.error}'),
                    );
                  }
          
                  // Handle loading data
                  debugPrint('Data: ${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      List<Events> eventsList = [];
                      for (var snapshotEvent in snapshot.data!.docs) {
                        Events event = Events.fromJson(
                            snapshotEvent.id, snapshotEvent.data());
                        eventsList.add(event);
                      }
                      return _buildTableCalendar(eventsList);
                    } else {
                      return _buildTableCalendar();
                    }
                  }
                },
              ),
              SizedBox(height: 8.sp),
              //_buildButtons(),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    ref
                        .read(globalsNotifierProvider.notifier)
                        .updateNewEvent(true);
          
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddEventScreen()));
          
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    // todo: add better error handling
                    //debugPrint(e);
                  }
                },
                child: const Text('Add Event'),
              ),
              SizedBox(height: 8.sp),
              // Build the event list below the calendar if events exist
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar([List<Events>? events, List<Trxn>? trxns]) {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      locale: 'en_US',
      eventLoader: (day) {
        return _getEventsForDay(day, events ?? []);
      },
      daysOfWeekHeight: 30,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(color: Colors.deepOrange[400]),
        todayDecoration: BoxDecoration(color: Colors.deepOrange[200]),
        markerDecoration: const BoxDecoration(color: Colors.deepPurpleAccent),
        outsideDaysVisible: false,
      ),
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        //if (format != _calendarFormat) {
        setState(() {
          _calendarFormat = format;
        });
        //}
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        formatButtonShowsNext: false,
        titleCentered: true,
        formatButtonTextStyle:
            const TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        decoration: BoxDecoration(color: Colors.amber),
        weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
      ),

      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay; // update `_focusedDay` here as well
          return _onDaySelected(selectedDay, focusedDay);
        });
      },
      //onRangeSelected: _onRangeSelected,
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    final _db = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      // Get all the events for the focusDay or the selectedDay
      stream: _db
          .collection('users')
          .doc(ref.read(globalsNotifierProvider).currentUserId)
          .collection('events')
          .where('eventDate',
              isGreaterThanOrEqualTo: DateTime(
                  _focusedDay.year, _focusedDay.month, _focusedDay.day))
          .where('eventDate',
              isLessThan: DateTime(
                  _focusedDay.year, _focusedDay.month, _focusedDay.day + 1))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: Text(
            'Loading...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
        } else {
          var doc = snapshot.data!.docs;
          return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(
                      '${doc[index]['eventName'] ?? 'n/a'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.blueAccent),
                    ),
                    subtitle: Text.rich(TextSpan(
                        text:
                            '${DateFormat('EE MM-dd-yyyy').format(doc[index]['eventDate'].toDate())}\n'
                            '${DateFormat('h:mm a').format(doc[index]['eventStartTime'].toDate())}, '
                            'Duration: ${doc[index]['eventDuration'] ?? 'n/a'} minutes',
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '\n${doc[index]['eventDescription'] ?? 'n/a'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.blueGrey),
                          )
                        ])),
                    //trailing: Text('MLS#: ${_event.mlsNumber ?? 'n/a'}'),
                    onTap: () {
                      ref
                          .read(globalsNotifierProvider.notifier)
                          .updateNewEvent(false);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEventScreen()));
                    },
                  ),
                );
              });
        }
      },
    );
  }

  Map<DateTime, List>? convertToMap(List<Events> item) {
    Map<DateTime, List>? result;

    for (int i = 0; i < item.length; i++) {
      Events data = item[i];
      //get the date and convert it to a DateTime variable
      //DateTime currentDate = DateFormat('MM-dd-yyyy - kk:mm').format(data.eventDate);
      DateTime currentDate = DateTime(
          data.eventDate!.year,
          data.eventDate!.month,
          data.eventDate!.day,
          data.eventDate!.hour,
          data.eventDate!.minute);

      List eventNames = [];
      //add the event name to the the eventNames list for the current date.
      //search for another event with the same date and populate the eventNames List.
      for (int j = 0; j < item.length; j++) {
        //create temp calendarItemData object.
        Events temp = item[j];
        //establish that the temp date is equal to the current date
        if (data.eventDate == temp.eventDate) {
          //add the event name to the event List.
          eventNames.add(temp.eventName);
        } //else continue
      }

      //add the date and the event to the map if the date is not contained in the map
      if (result == null) {
        result = {currentDate: eventNames};
      } else {
        result[currentDate] = eventNames;
      }
      return result;
    }
    return null;
  }
}
