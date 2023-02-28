// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required int price,
    required String cardName,
    required DateTime registerDate,
    required String detail,
  }) = _Event;
}
