import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/add_specific_config.dart';
import 'package:seeder/entity/config/specific_config_list.dart';

class SpecificConfig extends ConsumerWidget {
  final String entityId;
  const SpecificConfig(this.entityId);

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
                    child: SpecificConfigList(entityId)),
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
                            return AddSpecificConfig(entityId);
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
