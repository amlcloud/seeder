import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class GenerateTransactionsButton extends ConsumerWidget {
  final String entityId;
  GenerateTransactionsButton(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) => ElevatedButton(
      onPressed: () {
        /// Generates a transaction of random amount and balance
        FirebaseFirestore.instance
            .collection('entity/${entityId}/transaction')
            .add({
          'amount': (math.Random().nextDouble() * 999 + 1).toStringAsFixed(2),
          'balance': (math.Random().nextDouble() * 999 + 1).toStringAsFixed(2),
          'ben_name': "Beneficiary",
          'reference': "Example Transaction",
          'rem_name': "Remitter",
        });
      },
      child: Text('Generate'));
}
