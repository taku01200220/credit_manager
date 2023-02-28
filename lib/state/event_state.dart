import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventProvider =
    StateNotifierProvider<EventNotifier, List<Event>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<List<Event>> {
  EventNotifier() : super([]);

  Future<void> fetchEvent() async {
    state = await getEventFire();
  }

  Future<List<Event>> getEventFire() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .get();
    final event = snapshot.docs
        .map(
          (doc) => Event(
            id: doc.id,
            price: doc['price'] as int,
            cardName: doc['cardName'].toString(),
            registerDate: (doc['registerDate'] as Timestamp).toDate(),
            detail: doc['detail'].toString(),
          ),
        )
        .toList();
    return event;
  }

}
