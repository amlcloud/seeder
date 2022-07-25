import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/entity/transaction_list.dart';
import 'package:seeder/theme.dart';

import 'firebase_options.dart';

/// This function is for testing individual Widgets
///
/// To configure which widget you'd like to test
/// include it as a body in the [Scaffold].
///
/// Run it by clicking on the Run.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String testId = 'DcyMKCGiQ1ENnWaq7VVU';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MaterialApp(
          title: 'Data Generator',
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: Scaffold(body: TransactionList("DcyMKCGiQ1ENnWaq7VVU"))

          //EntityConfig('DcyMKCGiQ1ENnWaq7VVU')

          /// Insert your widget here for testing:
          //AddRecurrentPaymentDialog('DcyMKCGiQ1ENnWaq7VVU')
          //RecurrentIncome('DcyMKCGiQ1ENnWaq7VVU')
          // Text('another widget')
          ///
          ///
          ///
          )));
}
