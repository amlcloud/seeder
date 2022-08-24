import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.arrow_back),
        title: const Text("setting"), 
        actions: [IconButton(icon: Icon(Icons.close),onPressed: (){
          print("close!close!");
        }),
        ],
        backgroundColor: Colors.blue,
      ),
    );
  }
}
