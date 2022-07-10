import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/batch/batch_view_csv.dart';
import 'package:seeder/batch/entities_selector.dart';
import 'package:seeder/controls/doc_field_text_edit_delayed.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';

final activeEntity =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class BatchDetails extends ConsumerWidget {
  final String? entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  BatchDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => entityId == null
      ? Container()
      : Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Colors.grey,
              )),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(entityId!),
              DocFieldTextEditDelayed(
                  FirebaseFirestore.instance.doc('batch/${entityId}'), 'id'),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('batch/${entityId}'),
                'name',
              ),
              DocFieldTextEditDelayed(
                FirebaseFirestore.instance.doc('batch/${entityId}'),
                'desc',
              ),
              Divider(),
              EntitiesSelector(),
              Divider(),
              // ElevatedButton(onPressed: () {}, child: Text('Generate')),
              // Text("Output:"),
              // Card(
              //   child: Text('CSV output goes here...'),
              // ),
              // ElevatedButton(
              //     onPressed: () {
              //       final List<List<String>> exportList = [
              //         <String>["id", "name", "desc", "author", "timestamp"]
              //       ];
              //       List<String> clipboard = [];
              //       ref.watch(colSP('entity')).when(
              //             loading: () => [Container()],
              //             error: (e, s) => [ErrorWidget(e)],
              //             data: (entities) => entities.docs
              //                 .map(
              //                   (entity) => {
              //                     print('data is:' + entity['name'].toString()),
              //                     exportList.add(<String>[
              //                       entity["id"].toString(),
              //                       entity["name"].toString(),
              //                       entity["desc"].toString(),
              //                       entity["author"].toString(),
              //                       entity["time Created"].toString()
              //                     ]),
              //                     clipboard.add(entity.data().toString())
              //                   },
              //                 )
              //                 .toList(),
              //           );
              //       // final docRef = FirebaseFirestore.instance
              //       //     .collection('set/BUVlUXhvauQzw384GxE7/entity')
              //       //     .get();
              //       // docRef.then(
              //       //   (doc) {
              //       //     final data = doc.docs.asMap();
              //       //     data.forEach((key, value) {
              //       //       clipboard.add(value[key].toString());
              //       //       print("What is this: " + value[key]);
              //       //     });
              //       //     //clipboard.add(data.toString());
              //       //     print('data is: ' + data.toString());
              //       //   },
              //       // );
              //       String csv =
              //           ListToCsvConverter().convert(exportList).toString();
              //       Clipboard.setData(ClipboardData(text: csv));

              //       Fluttertoast.showToast(msg: 'Copied to clipboard');
              //     },
              //     child: Text('Copy To Clipboard'))
              BatchViewCsv(entityId!)
            ],
          )));
}
