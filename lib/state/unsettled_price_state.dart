import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final unsettledPriceProvider =
    StateNotifierProvider<UnsettledPriceNotifier, int>((ref) {
  return UnsettledPriceNotifier();
});

class UnsettledPriceNotifier extends StateNotifier<int> {
  UnsettledPriceNotifier() : super(0);

  void calcUnsettledPrice(List<Event> event, String cardName, String closingDate) {
    var price = 0;
    late DateTime startDate;
    late DateTime endDate;
    startDate = isStartDate(closingDate);
    endDate = isEndDate(closingDate);
    // List<Event> confirmEvent = [];
    for (var i = 0; i < event.length; i++) {
      if (event[i].cardName == cardName && event[i].registerDate.isAfter(startDate) && event[i].registerDate.isBefore(endDate)) {
        // confirmEvent.add(event[i]);
        price += event[i].price;
      }
    }
    state = price;
  }

  DateTime isStartDate(String closingDate) {
    late DateTime dt;

    if (int.parse((DateTime.now().day).toString()) <= int.parse(closingDate)) {
      String str = '${(DateTime.now().year).toString()}-${(DateTime.now().month - 1).toString()}-${int.parse(closingDate) + 1}';
      dt = DateFormat('yy-MM-dd').parse(str);
    } else if (int.parse((DateTime.now().day).toString()) > int.parse(closingDate)) {
      String str = '${(DateTime.now().year).toString()}-${(DateTime.now().month).toString()}-${int.parse(closingDate) + 1}';
      // dt = DateTime.parse(str);
      dt = DateFormat('yy-MM-dd').parse(str);
    }
    // print('start $dt');
    return dt;
  }

  DateTime isEndDate(String closingDate) {
    late DateTime dt;

    if (int.parse((DateTime.now().day).toString()) <= int.parse(closingDate)) {
      String str = '${(DateTime.now().year).toString()}-${(DateTime.now().month).toString()}-${closingDate} 23:59:59';
      dt = DateFormat('yy-MM-dd hh:mm:ss').parse(str);
    } else if (int.parse((DateTime.now().day).toString()) > int.parse(closingDate)) {
      String str = '${(DateTime.now().year).toString()}-${(DateTime.now().month + 1).toString()}-${closingDate} 23:59:59';
      // dt = DateTime.parse(str);
      dt = DateFormat('yy-MM-dd hh:mm:ss').parse(str);
    }
    // print('end $dt');
    return dt;
  }

}
