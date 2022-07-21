import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';
import 'package:intl/intl.dart';

class GenerateTransactionsButton extends ConsumerStatefulWidget {
  final String entityId;
  const GenerateTransactionsButton(this.entityId);

  @override
  GenerateTransactionsButtonState createState() =>
      GenerateTransactionsButtonState();
}

class GenerateTransactionsButtonState
    extends ConsumerState<GenerateTransactionsButton> {
  DateTimeRange? _selectedDateRange;

  // This function will be triggered when the floating button is pressed
  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20, top: 20),
        padding: EdgeInsets.only(bottom: 20, top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Row(
          children: <Widget>[
            Expanded(
                child: _selectedDateRange == null
                    ? Text("Select date range")
                    : Text(
                        "${formatter.format(_selectedDateRange!.start)} - ${formatter.format(_selectedDateRange!.end)}")),
            Expanded(
                child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    _show();
                  },
                  child: Icon(Icons.date_range)),
            )),

            //Expanded(child: MyStatefulWidget()),
            Expanded(
                child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    generate();
                  },
                  child: Text('Generate')),
            )),
          ],
        ));
  }

  deleteCol() {
    FirebaseFirestore.instance
        .collection('entity/${widget.entityId}/transaction')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  generate() {
    deleteCol();
    List dates = generateDays(
        Jiffy(_selectedDateRange!.start), Jiffy(_selectedDateRange!.end));

    // for (var element in dates) {
    //   for (var config in allConfigsInRandomOrder) {
    //     if (config.isRandom()) {
    //       if (!config
    //           .isComplete()) // check if grocery is already done this week
    //       {
    //         //calculate probability that is growing as there is less time left in the month
    //         final prob = calcProbability(
    //             config); // for Monday - 10%, Wed-33%, Friday-99%

    //         createTransaction(config, prob);
    //       }
    //     } else {
    //       if (!config
    //           .isSupposedToHappenToday()) // check if salary was already paid this month
    //       {
    //         createTransaction(config);
    //       }
    //     }
    //   }
    // }

    // for (var element in dates) {
    //   //print("this is sample: ${element.dateTime}");
    //   FirebaseFirestore.instance
    //       .collection('entity/${widget.entityId}/transaction')
    //       .add({
    //     'amount': math.Random().nextDouble() * 999 + 1,
    //     'balance': (math.Random().nextDouble() * 999 + 1).toStringAsFixed(2),
    //     'ben_name': "Beneficiary",
    //     'reference': "Example Transaction",
    //     'rem_name': "Remitter",
    //     't': element.dateTime,
    //     'day': element.format(DATE_FORMAT),
    //   });
    // }
  }
}
