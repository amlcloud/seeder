import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends ConsumerWidget {
  CustomDatePicker(this.header, this.inputController);
  final TextEditingController inputController;
  final String header;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final disDateTime =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(null));
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void selectDate() async {
      final DateTime? result = await showDatePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        initialDate: DateTime.now(),
      );
      if (result != null) {
        inputController.text = formatter.format(result);
        ref.read(disDateTime.notifier).value = formatter.format(result);
      }
    }

    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: Text(header)),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(ref.watch(disDateTime) ??
                              formatter.format(DateTime.now()))),
                      IconButton(
                          onPressed: selectDate,
                          icon: Icon(Icons.date_range_outlined))
                    ],
                  )
                ],
              ),
            )));
  }
}
