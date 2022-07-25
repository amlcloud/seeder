import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeder/entity/generate_transactions_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GenerateTransactions extends ConsumerStatefulWidget {
  final String entityId;
  const GenerateTransactions(this.entityId);

  @override
  GenerateTransactionsButtonState createState() =>
      GenerateTransactionsButtonState();
}

class GenerateTransactionsButtonState
    extends ConsumerState<GenerateTransactions> {
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
      //print(result.start.toString());
      setState(() {
        selectedDateRange = result;
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
                child: selectedDateRange == null
                    ? Text("Select date range")
                    : Text(
                        "${formatter.format(selectedDateRange!.start)} - ${formatter.format(selectedDateRange!.end)}")),
            Expanded(
                child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    _show();
                  },
                  child: Icon(Icons.date_range)),
            )),
            Expanded(
                child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (selectedDateRange != null) {
                      AddTrnsactionToServer(
                          selectedDateRange!, widget.entityId, ref);
                    } else {
                      Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        msg: 'Please select a date range for this transaction',
                      );
                    }
                  },
                  child: Text('Generate')),
              // GenerateTransactionsButton(
              //     selectedDateRange!, widget.entityId),
            )),
          ],
        ));
  }
}
