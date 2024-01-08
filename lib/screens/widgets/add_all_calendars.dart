//*********************************************
//  Deal Diligence was designed and created by      *
//  Nathan Kane                               *
//  copyright 2023                            *
//*********************************************

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:deal_diligence/Providers/event_provider.dart';

class AddEventsToAllCalendars {
  static void addEvent(Events event) {
    Add2Calendar.addEvent2Cal(buildEvent(event));
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
