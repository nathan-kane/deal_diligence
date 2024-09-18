//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:deal_diligence/Providers/event_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId:
      '394692266013-pj87pfid8p2l955nmua43sd6v3g5aqu3.apps.googleusercontent.com',
  scopes: [
    'https://www.googleapis.com/auth/calendar',
  ],
);

class AddEventsToAllCalendars {
  GoogleSignInAuthentication? _auth;

  static void addEvent(Events event) async {
    if (!kIsWeb) {
      Add2Calendar.addEvent2Cal(buildEvent(event));
    }
  }

  void addEvent2(Events eventCal) async {
    if (!kIsWeb) {
      // Add2Calendar.addEvent2Cal(buildEvent(event));
    } else {
      try {
        final signInAccountSilently = await _googleSignIn.signInSilently();
        if (signInAccountSilently != null) {
          _auth = await signInAccountSilently.authentication;
        } else {
          final signInAccount = await _googleSignIn.signIn();
          _auth = await signInAccount?.authentication;
        }

        if (_auth == null) return;
        const String calendarId =
            "primary"; // Use 'primary' for the default calendar.
        const String url =
            'https://www.googleapis.com/calendar/v3/calendars/$calendarId/events';
        // final event = {
        //   "summary": eventCal.eventName,
        //   "description": eventCal.eventDescription,
        //   "start": {
        //     "dateTime": eventCal.eventStartTime?.toUtc().toIso8601String(),
        //     "timeZone": "UTC"
        //   },
        //   "end": {
        //     "dateTime": eventCal.eventStartTime?.add(Duration(minutes: int.parse(eventCal.eventDuration ?? "0")))
        //         .toUtc()
        //         .toIso8601String(),
        //     "timeZone": "UTC"
        //   },
        // };
        final event = {
          "summary": eventCal.eventName,
          "description": eventCal.eventDescription,
          "location": eventCal.location, // Add location
          "start": {
            "dateTime": eventCal.eventStartTime?.toUtc().toIso8601String(),
            "timeZone": "UTC",
          },
          "end": {
            "dateTime": eventCal.eventStartTime
                ?.add(
                    Duration(minutes: int.parse(eventCal.eventDuration ?? "0")))
                .toUtc()
                .toIso8601String(),
            "timeZone": "UTC",
          },
          "recurrence": [
            "RRULE:FREQ=DAILY;INTERVAL=${eventCal.interval};COUNT=${eventCal.occurrences}"
          ], // Recurrence rule: daily with interval and occurrences
          // "reminders": {
          //   "useDefault": false,
          //   "overrides": [
          //     {
          //       "method": "popup",
          //       "minutes": eventCal.frequency ?? 10
          //     }, // Reminder with interval
          //   ],
          // },
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${_auth!.accessToken}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(event),
        );
        if (response.statusCode == 200) {
          debugPrint('Event created successfully');
        } else {
          debugPrint('Error creating event: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint("RethrowError: ${e.toString()}");
        rethrow;
      }
    }
  }

  static Event buildEvent(Events event) {
    Frequency freq = Frequency.yearly;

    if (event.frequency != "" && event.frequency != null) {
      if (event.frequency == 'daily') {
        freq = Frequency.daily;
      } else if (event.frequency == 'weekly') {
        freq = Frequency.weekly;
      } else if (event.frequency == 'monthly') {
        freq = Frequency.monthly;
      }
    }

    if (event.eventDuration == "" || event.eventDuration == null) {
      event.eventDuration = "30";
    }

    return Event(
      title: event.eventName!,
      description: event.eventDescription,
      location: event.location,
      startDate: event.eventDate!,
      endDate: event.eventStartTime!
          .add(Duration(minutes: int.parse(event.eventDuration!))),
      allDay: event.allDay,
      // iosParams: const IOSParams(
      //   reminder: Duration(minutes: 40),
      //   url: "http://example.com",
      // ),
      androidParams: const AndroidParams(
        emailInvites: ["nkane1234@gmail.com"],
      ),
      recurrence: Recurrence(
        frequency: freq,
        endDate: event.recurrenceEndDate,
      ),
    );
  }
}
