import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntityParams extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        Text('income type and income goes here'),
// Income()
        Text('random spending goes here'),
        Text('random income goes here')
      ]);
}
