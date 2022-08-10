import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  ThemeStateNotifier(super.state);
  void changeTheme() {
    state = !state;
  }
}

final themeStateNotifierProvider =
    StateNotifierProvider<ThemeStateNotifier, bool>(
        (ref) => ThemeStateNotifier(false));
