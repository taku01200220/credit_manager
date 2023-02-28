import 'package:credit_manager/importer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final detailEventListProvider =
    StateNotifierProvider<DetailEventListNotifier, List<Event>>((ref) {
  return DetailEventListNotifier();
});

class DetailEventListNotifier extends StateNotifier<List<Event>> {
  DetailEventListNotifier() : super([]);

  Future<void> fetchDetailEventList(List<Event> event, String cardName, DateTime selectMonth, String closingDate) async {
    List<Event> events = [];
    late DateTime startDate;
    late DateTime endDate;
    startDate = isStartDate(closingDate, selectMonth);
    endDate = isEndDate(closingDate, selectMonth);
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

    DateTime isStartDate(String closingDate, DateTime selectedMonth) {
    late DateTime dt;
    String str = '${(selectedMonth.year).toString()}-${(selectedMonth.month - 2).toString()}-${int.parse(closingDate) + 1}';
    dt = DateFormat('yy-MM-dd').parse(str);
    // print('start $dt');
    return dt;
  }

  DateTime isEndDate(String closingDate, DateTime selectedMonth) {
    late DateTime dt;
    String str = '${(selectedMonth.year).toString()}-${(selectedMonth.month - 1).toString()}-${closingDate} 23:59:59';
    dt = DateFormat('yy-MM-dd hh:mm:ss').parse(str);
    // print('end $dt');
    return dt;
  }

}
