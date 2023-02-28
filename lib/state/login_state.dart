import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginInfoProvider = ChangeNotifierProvider<LoginInfoNotifier>((ref) {
  return LoginInfoNotifier();
});

class LoginInfoNotifier extends ChangeNotifier {

  var _uid = FirebaseAuth.instance.currentUser?.uid;
  String? get uid => _uid;
  bool get loggedIn => _uid != null;

  void login(String? uid) {
    _uid = uid;
    notifyListeners();
  }

  void logout() {
    _uid = null;
    notifyListeners();
  }

}
