import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// FireAuth関連のメンバ関数
class AuthFire {
  // アカウントの新規登録
  Future<void> registerFire(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    final userID = user?.uid;
    final uid = userID!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    await userDoc.set(<String, String>{'email': email});
  }

  // ログイン
  Future<void> loginFire(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  // ログアウト
  Future<void> logoutFire() async {
    await FirebaseAuth.instance.signOut();
  }

  // パスワードリセットメールの送信
  Future<void> sendPasswordResetMailFire(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // アカウントの削除
  Future<void> deleteAccountFire() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

}
