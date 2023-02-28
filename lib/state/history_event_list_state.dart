import 'package:credit_manager/importer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final historyEventListProvider =
    StateNotifierProvider<HistoryEventListNotifier, List<Event>>((ref) {
  return HistoryEventListNotifier();
});

class HistoryEventListNotifier extends StateNotifier<List<Event>> {
  HistoryEventListNotifier() : super([]);

  Future<void> fetchHistoryEventList(String cardName, List<Event> event, DateTime startDate, DateTime endDate) async {
    final events = <Event>[];
    for (var i = 0; i < event.length; i++) {
      if (event[i].cardName == cardName && event[i].registerDate.isAfter(startDate) && event[i].registerDate.isBefore(endDate)) {
        events.add(
          event[i],
        );
      }
    }
    events.sort((a, b) => -a.registerDate.compareTo(b.registerDate));
    state = events;
  }
}
