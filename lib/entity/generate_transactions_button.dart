import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:seeder/entity/generate_transactions.dart';
import 'package:seeder/providers/firestore.dart';

class TransactionsWidget extends ConsumerWidget {
  final String entityId;
  const TransactionsWidget(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTimeRange? selectedDateRange;

    void _show() async {
      final DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        currentDate: DateTime.now(),
        saveText: 'Done',
      );

      if (result != null) {
        FirebaseFirestore.instance.collection("entity").doc(entityId).update({
          'startDate': result.start,
          'endDate': result.end,
        });
      }
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Column(
      children: <Widget>[
        Center(
            child: Container(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: ref.watch(docSP('entity/${entityId}')).when(
                    loading: () => Container(),
                    error: (e, s) => ErrorWidget(e),
                    data: (docSnapshot) {
                      if (docSnapshot.data()!['startDate'] != null) {
                        selectedDateRange = DateTimeRange(
                            start: docSnapshot.data()!['startDate'].toDate(),
                            end: docSnapshot.data()!['endDate'].toDate());
                      }
                      return selectedDateRange == null
                          ? Text("Select date range")
                          : Text(
                              "${formatter.format(selectedDateRange!.start)} - ${formatter.format(selectedDateRange!.end)}");
                    }))),
        Row(
          children: <Widget>[
            Expanded(
                child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _show();
                },
                icon: Icon(Icons.date_range),
                label: Text("Pick date range"),
              ),
            )),
            Expanded(
                child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (selectedDateRange != null) {
                      addTrnsactionToServer(selectedDateRange!, entityId, ref);
                    } else {
                      // Fluttertoast.showToast(
                      //   gravity: ToastGravity.CENTER,
                      //   timeInSecForIosWeb: 2,
                      //   msg:
                      //       'Please select a date range for this transaction',
                      // );
                    }
                  },
                  child: Text('Generate')),
            )),
          ],
        )
      ],
    );
  }
}
