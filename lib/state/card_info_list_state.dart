import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_manager/importer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final cardInfoListProvider =
    StateNotifierProvider<CardInfoListNotifier, List<CardInfo>>((ref) {
  return CardInfoListNotifier();
});

class CardInfoListNotifier extends StateNotifier<List<CardInfo>> {
  CardInfoListNotifier() : super([]);

  Future<void> fetchCardInfoList() async {
    state = await getCardInfoListFire();
  }

  Future<List<CardInfo>> getCardInfoListFire() async {
    var cardInfoList = <CardInfo>[];
    var notMainCardList = <CardInfo>[];
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cardInfo')
        .get();
    final cardInfo = snapshot.docs
        .map(
          (doc) => CardInfo(
            id: doc.id,
            cardName: doc['cardName'].toString(),
            closingDate: doc['closingDate'].toString(),
            paymentDate: doc['paymentDate'].toString(),
            labelColor: doc['labelColor'].toString(),
            mainCard: doc['mainCard'] as bool,
          ),
        )
        .toList();
    cardInfoList =
        cardInfo.where((cardInfo) => cardInfo.mainCard == true).toList();
    notMainCardList =
        cardInfo.where((cardInfo) => cardInfo.mainCard == false).toList();
    cardInfoList.addAll(notMainCardList);
    return cardInfoList;
  }
}
