import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeder/dialogs/add_periodic_config.dart';
import 'package:seeder/entity/config/config_list.dart';
import 'package:seeder/entity/config/selected_config_list.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PeriodicConfig extends ConsumerWidget {
  final String entityId;

  const PeriodicConfig(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Column(children: [
          Expanded(
              child: Column(
            children: [
              Text('available periodic templates'),
              Expanded(
                child: SingleChildScrollView(
                    child: ConfigList(entityId, "periodicConfig")),
              ),
              Divider(),
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Add templates '),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddPeriodicConfig();
                          });
                    },
                  )
                ],
              ))
            ],
          ))
        ]));
  }
}
