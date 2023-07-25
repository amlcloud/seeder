import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/tran_config/tran_config_details.dart';
import 'package:seeder/tran_config/tran_config_list.dart';

import '../main_app_bar.dart';

final activeTranConfig = StateNotifierProvider<GenericStateNotifier<DR?>, DR?>(
    (ref) => GenericStateNotifier<DR?>(null));

class TranConfigPage extends ConsumerWidget {
  static String get routeName => 'configs';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: MainAppBar.getBar(context, ref),
        body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 20,
                          child:
                              SingleChildScrollView(child: TranConfigList())),
                      Flexible(child: buildAddButton(context, ref)),
                    ],
                  )),
              Expanded(
                flex: 2,
                child: ref.watch(activeTranConfig) == null
                    ? Container()
                    : TranConfigDetails(ref.watch(activeTranConfig)!),
              )
            ]));
  }

  buildAddButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          kDB
              .collection('periodicConfig')
              .add({'t': FieldValue.serverTimestamp()});
        },
        child: Text('Add'));

    // return Padding(
    //   padding: EdgeInsets.all(5),
    //   child: ElevatedButton.icon(
    //     style: ElevatedButton.styleFrom(
    //       minimumSize: Size(400, 40),
    //     ),
    //     label: const Text('Add periodic config'),
    //     onPressed: () {
    //       showDialog(
    //           context: context,
    //           builder: (BuildContext context) {
    //             return AddConfigField("periodicConfig", entityId);
    //           });
    //     },
    //     icon: Icon(Icons.add),
    //   ),
    // );
  }
}
