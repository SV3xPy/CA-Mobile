import 'package:ca_mobile/features/events/repository/event_repository.dart';
import 'package:ca_mobile/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventControllerProvider = Provider((ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  return EventController(eventRepository: eventRepository, ref: ref);
});

/*final eventDataAuthProvider = FutureProvider((ref) {
  final eventController = ref.watch(eventControllerProvider);
  return eventController.getUserData();
});*/

class EventController {
  final EventRepository eventRepository;
  final ProviderRef ref;

  EventController({
    required this.eventRepository,
    required this.ref,
  });

  Future<EventModel?> getEventData() async {
    EventModel? event = await eventRepository.getEventData();
    return event;
  }

  Future<List<EventModel>> getAllEventsData() async {
    List<EventModel> events = await eventRepository.getAllEventsData();
    return events;
  }

  Future<List<EventModel>> getEventsByDate() async {
    List<EventModel> eventsDate = await eventRepository.getEventsByDate();
    return eventsDate;
  }

  Future<void> deleteEvent() async {
    await eventRepository.deleteEvent();
  }

  void saveEventDataToFirebase(
      BuildContext context,
      String title,
      DateTime from,
      DateTime to,
      String subject,
      String description,
      String type,
      String color) {
    eventRepository.saveEventData(
        title: title,
        from: from,
        to: to,
        subject: subject,
        description: description,
        type: type,
        color: color,
        ref: ref,
        context: context);
  }

  void setDate(DateTime date) {
    print("Fecha establecida en controlaador: $date");
    eventRepository.setDate(date);
  }
  //Stream<EventModel> eventDataById(String userId) {
  //return eventRepository.eventData(userId);
  //}
}
