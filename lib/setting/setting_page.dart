import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/setting/setting.dart';

class SettingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // use default leading arrow with router automatically
        title: const Text("setting"),
        actions: [],
        backgroundColor: Colors.blue,
      ),
      body: Setting(),
    );
  }
}
