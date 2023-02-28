import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// イベント追加のメンバ関数
class CardFire {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  // カードの追加
  Future<void> addCardFire(
    String cardName,
    String closingDate,
    String paymentDate,
    String labelColor,
    bool mainCard,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cardInfo')
        .add(
      <String, dynamic>{
        'cardName': cardName,
        'closingDate': closingDate,
        'paymentDate': paymentDate,
        'labelColor': labelColor,
        'mainCard': mainCard,
      },
    );
  }

  // カードを削除
  Future<void> deleteCardFire(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cardInfo')
        .doc(id)
        .delete();
  }

  // カードを更新
  Future<void> updateCardFire(
    String id,
    String cardName,
    String closingDate,
    String paymentDate,
    String labelColor,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cardInfo')
        .doc(id)
        .update(
      <String, dynamic>{
        'cardName': cardName,
        'closingDate': closingDate,
        'paymentDate': paymentDate,
        'labelColor': labelColor,
      },
    );
  }
}
