import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventSortProvider =
    StateNotifierProvider<EventSortNotifier, List<Event>>((ref) {
  return EventSortNotifier();
});

class EventSortNotifier extends StateNotifier<List<Event>> {
  EventSortNotifier() : super([]);

  Future<void> fetchRecentlyEvent(String cardName, List<Event> event) async {
    List<Event> recentryEvents;
    recentryEvents =
        event.where((event) => event.cardName == cardName).toList();
    recentryEvents.sort((a, b) => -a.registerDate.compareTo(b.registerDate));
    if (recentryEvents.length >= 5) {
      recentryEvents.removeRange(4, recentryEvents.length);
    }
    state = recentryEvents;
  }

}
