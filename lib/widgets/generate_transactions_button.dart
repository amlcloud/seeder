import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateTransactionsButton extends ConsumerWidget {
  final String entityId;
  GenerateTransactionsButton(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
      onPressed: () {
        ///
      },
      child: Text('Generate'));
}
