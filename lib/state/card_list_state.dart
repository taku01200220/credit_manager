import 'package:credit_manager/importer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cardListProvider =
    StateNotifierProvider<CardListNotifier, List<String>>((ref) {
  return CardListNotifier();
});

class CardListNotifier extends StateNotifier<List<String>> {
  CardListNotifier() : super([]);

  Future<void> fetchCardList(List<CardInfo> cardInfoList) async {
    // 支払い元ユーザのlistを作成
    final cardList = <String>[];
    for (var i = 0; i < cardInfoList.length; i++) {
      cardList.add(
        cardInfoList[i].cardName,
      );
    }
    state = cardList;
  }

}
