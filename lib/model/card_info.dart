// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';
part 'card_info.freezed.dart';

@freezed
class CardInfo with _$CardInfo {
  const factory CardInfo({
    required String id,
    required String cardName,
    required String closingDate,
    required String paymentDate,
    required String labelColor,
    required bool mainCard,
  }) = _CardInfo;
}
