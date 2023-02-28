import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// イベント追加のメンバ関数
class EventFire {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  // イベントの追加
  Future<void> addEventFire(
    int price,
    String cardName,
    DateTime registerDate,
    String detail,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .add(
      <String, dynamic>{
        'price': price,
        'cardName': cardName,
        'registerDate': registerDate,
        'detail': detail,
      },
    );
  }

  // イベントの削除
  Future<void> deleteEventFire(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .doc(id)
        .delete();
  }

  // イベントの削除（カード削除時、cardNameが同一のイベントを削除）
  Future<void> deleteCardWithEventFire(String cardName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .where('cardName', isEqualTo: cardName)
        .get()
        .then((QuerySnapshot snapshot) async {
      for (final doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('event')
            .doc(doc.id)
            .delete();
      }
    });
  }

  // イベントの更新
  Future<void> updateEventFire(
    String id,
    int price,
    String cardName,
    DateTime registerDate,
    String detail,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .doc(id)
        .update(
      <String, dynamic>{
        'price': price,
        'cardName': cardName,
        'registerDate': registerDate,
        'detail': detail,
      },
    );
  }

  // イベントの更新（カード更新時、cardNameが同一のイベントを更新）
  Future<void> updateCardWithEventFire(String oldName, String newName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('event')
        .where('cardName', isEqualTo: oldName)
        .get()
        .then((QuerySnapshot snapshot) async {
      for (final doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('event')
            .doc(doc.id)
            .update(
          <String, dynamic>{
            'cardName': newName,
          },
        );
      }
    });
  }
}
