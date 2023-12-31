import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:deal_diligence/Providers/event_provider.dart';

class AddEventsToAllCalendars {
  // addNormalEvent(title, description, startDate, endDate, allDay) {
  //   Add2Calendar.addEvent2Cal(
  //     buildEvent(),
  //   );
  // }

  addEvent(Events event) {
    Add2Calendar.addEvent2Cal(buildEvent(event));
  }

  Event buildEvent(Events event) {
    int eventRecurrenceDays =
        event.recurrenceEndDate!.difference(event.eventDate!).inDays.abs();

    Frequency freq = Frequency.daily;

    if (event.frequency == 'daily') {
      freq = Frequency.daily;
    } else if (event.frequency == 'weekly') {
      freq = Frequency.weekly;
    } else if (event.frequency == 'monthly') {
      freq = Frequency.monthly;
    } else {
      freq = Frequency.yearly;
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
        //endDate: event.eventStartTime!.add(Duration(days: eventRecurrenceDays)),
      ),
    );
  }
}
