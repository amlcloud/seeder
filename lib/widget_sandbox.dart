import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/theme.dart';

import 'entity/create_recurrent_payment_dialog.dart';
import 'entity/config/entity_config.dart';
import 'firebase_options.dart';

/// This function is for testing individual Widgets
///
/// To configure which widget you'd like to test
/// include it as a body in the [Scaffold].
///
/// Run it by clicking on the Run.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MaterialApp(
          title: 'Data Generator',
          themeMode: ThemeMode.dark,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: Scaffold(body: EntityConfig('DcyMKCGiQ1ENnWaq7VVU')

              /// Insert your widget here for testing:
              //AddRecurrentPaymentDialog('DcyMKCGiQ1ENnWaq7VVU')
              //RecurrentIncome('DcyMKCGiQ1ENnWaq7VVU')
              // Text('another widget')
              ///
              ///
              ///
              ))));
}
