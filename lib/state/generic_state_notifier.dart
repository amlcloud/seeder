import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenericStateNotifier<V> extends StateNotifier<V> {
  GenericStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}

class SortStateNotifier<V> extends StateNotifier<V> {
  SortStateNotifier(V d) : super(d);

  set value(V v) {
    state = v;
  }

  V get value => state;
}

final activeSort =
    StateNotifierProvider<SortStateNotifier<String?>, String?>(
        (ref) =>SortStateNotifier<String?>(null));