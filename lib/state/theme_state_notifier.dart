import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/main.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;
  ThemeStateNotifier(bool loginState) : super(false) {
    if (loginState == true && auth.currentUser != null) {
      var userSettingDoc =
          dbInstance.collection('user').doc(auth.currentUser!.uid);
      Future theme = userSettingDoc.get().then((value) {
        print('theme' + value.toString());
        return value['themeMode'];
      });
      theme
          .then((value) {
            bool isDark = value == 'light' ? false : true;
            return isDark;
          })
          .then((isDark) => state = isDark)
          .whenComplete(() => print(state));
    }
  }
  void changeTheme() {
    state = !state;
    String themeMode = state == false ? 'light' : 'dark';
    if (auth.currentUser != null) {
      var userSettingDoc =
          dbInstance.collection('user').doc(auth.currentUser!.uid);
      userSettingDoc.set({'themeMode': themeMode});
      // print(userSettingDoc);
    }
  }
}

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotifier, bool>((ref) {
  var loginState = ref.watch(isLoggedIn);
  return ThemeStateNotifier(loginState);
}, dependencies: [isLoggedIn]);
