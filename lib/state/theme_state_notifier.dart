import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;
  ThemeStateNotifier(super.state) {}
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
    StateNotifierProvider<ThemeStateNotifier, bool>(
        (ref) => ThemeStateNotifier(false));
