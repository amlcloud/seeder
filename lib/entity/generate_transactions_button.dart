import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:jiffy/jiffy.dart';
import 'package:quiver/time.dart';
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

  generate() async {
    deleteCol();
    var addonce = true;
    var weekCounter = 1;
    var monthCounter = 0;
    var quaterCounter = 0;
    double latestbalance = 0.0;
    var weekList = [];
    var monthList = [];
    var quaterList = [];
    List dates = generateDays(
        Jiffy(_selectedDateRange!.start), Jiffy(_selectedDateRange!.end));

    var random = math.Random();
    var periodicList = await FirebaseFirestore.instance
        .collection('entity')
        .doc(widget.entityId)
        .collection('periodicConfig')
        .get();
    var randomList = await FirebaseFirestore.instance
        .collection('entity')
        .doc(widget.entityId)
        .collection('randomConfig')
        .get();

    periodicList.docs
        .where((weekEl) => weekEl['period'] == 'Week')
        .forEach((element) {
      var temp = element.data();
      temp['benName'] = element.id.toString();
      temp['weekCounter'] = random.nextInt(7);
      weekList.add(temp);
    });

    periodicList.docs
        .where((weekEl) => weekEl['period'] == 'Month')
        .forEach((element) {
      var temp = element.data();
      temp['benName'] = element.id.toString();
      temp['monthCounter'] = random.nextInt(28);
      monthList.add(temp);
    });

    periodicList.docs
        .where((weekEl) => weekEl['period'] == 'Quarter')
        .forEach((element) {
      var temp = element.data();
      temp['benName'] = element.id.toString();
      temp['quaterCounter'] = random.nextInt(84);
      quaterList.add(temp);
    });

    print("random list ${quaterList}");

    for (var dateIterator in dates) {
      weekList
          .where((dayele) => dayele['weekCounter'] == weekCounter)
          .forEach((weekData) {
        double tempBal = weekData['minAmount'] +
            random.nextInt(weekData['maxAmount'] - weekData['minAmount']);

        if (addonce) {
          AddTrnsaction(weekData['benName'], dateIterator, tempBal, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = tempBal;
          addonce = false;
        } else {
          var balance = weekData['credit']!
              ? latestbalance + tempBal
              : latestbalance - tempBal;
          balance = double.parse(balance.toString());
          //print("is empte ${latestbalance}");

          AddTrnsaction(weekData['benName'], dateIterator, balance, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = balance.toDouble();
        }

        //print("I am printing ${weekData} counter:${weekCounter}");
      });

      monthList
          .where((dayele) => dayele['monthCounter'] == monthCounter)
          .forEach((weekData) {
        //print("I am hited by month");
        double tempBal = weekData['minAmount'] +
            random.nextInt(weekData['maxAmount'] - weekData['minAmount']);
        //print("random amount ${tempBal}");

        if (addonce) {
          AddTrnsaction(weekData['benName'], dateIterator, tempBal, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = tempBal;

          addonce = false;
        } else {
          var balance = weekData['credit']!
              ? latestbalance + tempBal
              : latestbalance - tempBal;
          balance = double.parse(balance.toString());
          //print("is empte ${latestbalance}");

          AddTrnsaction(weekData['benName'], dateIterator, balance, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = balance.toDouble();
        }

        //print("I am printing ${weekData} counter:${weekCounter}");
      });
      print("random data ${quaterCounter}");

      quaterList
          .where((quaterele) => quaterele['quaterCounter'] == quaterCounter)
          .forEach((weekData) {
        print("I am hited by month quater");
        double tempBal = weekData['minAmount'] +
            random.nextInt(weekData['maxAmount'] - weekData['minAmount']);
        //print("random amount ${tempBal}");

        if (addonce) {
          AddTrnsaction(weekData['benName'], dateIterator, tempBal, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = tempBal;

          addonce = false;
        } else {
          var balance = weekData['credit']!
              ? latestbalance + tempBal
              : latestbalance - tempBal;
          balance = double.parse(balance.toString());
          //print("is empte ${latestbalance}");

          AddTrnsaction(weekData['benName'], dateIterator, balance, tempBal,
              weekData['credit'] ? "Credit" : "Debit");
          latestbalance = balance.toDouble();
        }

        //print("I am printing ${weekData} counter:${weekCounter}");
      });

      if (weekCounter == 7) {
        weekCounter = 0;
      }
      if (monthCounter == 28) {
        monthCounter = 0;
      }
      if (quaterCounter == 84) {
        quaterCounter = 0;
      }
      quaterCounter++;
      monthCounter++;
      weekCounter++;
    }
  }

  AddTrnsaction(
    String remName,
    Jiffy dx,
    dynamic balance,
    dynamic amount,
    String crdb,
  ) {
    FirebaseFirestore.instance
        .collection('entity/${widget.entityId}/transaction')
        .add({
      //'amount': math.Random().nextDouble() * 999 + 1,
      //'balance': (math.Random().nextDouble() * 999 + 1).toStringAsFixed(2),

      'amount': amount,
      'balance': balance,
      'ben_name': "Beneficiary",
      'reference': "Example Transaction",
      'rem_name': remName,
      'Type': crdb,
      't': dx.dateTime,
      'day': dx.format(DATE_FORMAT),
    });
  }

  Future<Map<String, dynamic>> fetchLastData() async {
    Map<String, dynamic> collection = {};
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('entity')
          .doc(widget.entityId)
          .collection('transaction')
          .orderBy("day", descending: true)
          .get();

      collection = data.docs.first.data();
      //print("sample collection ${collection}");
      //print("sample collection ${data.docs.first.data()}");
    } catch (e) {
      print('error: $e');
    }
    return collection;
  }
}
