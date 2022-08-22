import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/controls/assistant.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/controls/scrollable_table.dart';
import 'package:seeder/field/test_field.dart';
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

          ///home: Scaffold(body: Group(child: ScrollableTable()))

          //EntityConfig('DcyMKCGiQ1ENnWaq7VVU')

          /// Insert your widget here for testing:
          //AddRecurrentPaymentDialog('DcyMKCGiQ1ENnWaq7VVU')
          //RecurrentIncome('DcyMKCGiQ1ENnWaq7VVU')
          // Text('another widget')
          ///
          /// Example of Field widget By Thuvarakan*
          home: Scaffold(
              //body: Group(child: TestField())
              body: Stack(children: [
            Row(children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(
                  color: Colors.red,
                ),
              ))),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(
                  color: Colors.green,
                ),
              ))),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(
                          color: Colors.yellow,
                        ),
                      ),
                      child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet tellus cras adipiscing enim eu. Elementum nibh tellus molestie nunc. Tincidunt dui ut ornare lectus sit amet est. Massa placerat duis ultricies lacus sed turpis tincidunt id aliquet. Interdum velit laoreet id donec ultrices tincidunt arcu non sodales. Enim ut tellus elementum sagittis vitae et. Sed euismod nisi porta lorem mollis aliquam ut porttitor leo. Pretium vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae. Dignissim convallis aenean et tortor. Habitant morbi tristique senectus et netus. Lacus luctus accumsan tortor posuere ac ut consequat. Penatibus et magnis dis parturient. Aliquam ultrices sagittis orci a scelerisque purus semper eget duis. Nec nam aliquam sem et. Sed risus ultricies tristique nulla aliquet enim tortor at auctor. Sit amet consectetur adipiscing elit pellentesque habitant morbi tristique. Condimentum lacinia quis vel eros donec ac odio tempor. Urna porttitor rhoncus dolor purus non enim. Sem et tortor consequat id porta. Est placerat in egestas erat imperdiet sed euismod nisi. Justo donec enim diam vulputate ut. Fringilla urna porttitor rhoncus dolor purus non enim praesent. Bibendum enim facilisis gravida neque convallis. Suspendisse sed nisi lacus sed viverra. Ultrices eros in cursus turpis. Ut porttitor leo a diam sollicitudin tempor id eu. Arcu risus quis varius quam quisque id diam vel quam. Faucibus turpis in eu mi bibendum neque. Gravida in fermentum et sollicitudin. Pretium lectus quam id leo in vitae turpis massa. Turpis massa sed elementum tempus egestas sed sed. Iaculis urna id volutpat lacus laoreet non curabitur. Sodales neque sodales ut etiam sit amet. Consectetur libero id faucibus nisl tincidunt eget nullam non nisi. Posuere sollicitudin aliquam ultrices sagittis. Dictum sit amet justo donec enim diam. Nec nam aliquam sem et tortor consequat id porta nibh. Suspendisse interdum consectetur libero id faucibus. Venenatis tellus in metus vulputate eu scelerisque. Risus quis varius quam quisque id diam. Varius duis at consectetur lorem donec massa. Ac tortor vitae purus faucibus. Mauris commodo quis imperdiet massa tincidunt nunc. Id nibh tortor id aliquet lectus proin. Tristique risus nec feugiat in fermentum posuere. Felis eget nunc lobortis mattis aliquam faucibus purus in. Semper quis lectus nulla at. Nisi lacus sed viverra tellus in hac habitasse platea dictumst. In iaculis nunc sed augue lacus viverra vitae.",
                          style: TextStyle(fontSize: 20))))
            ]),
            assistant(),
          ])))));
}
