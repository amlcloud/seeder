import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seeder/state/generic_state_notifier.dart';

class FieldSelector extends ConsumerWidget {
  final fieldInput2 =
      StateNotifierProvider<GenericStateNotifier<String?>, String?>(
          (ref) => GenericStateNotifier<String?>(''));

  final String name;
  final String type;
  final TextEditingController fieldInputController;
  FieldSelector(this.name, this.type, this.fieldInputController);

  final creditDebit = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
      (ref) => GenericStateNotifier<bool>(true));

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    void selectDate() async {
      final DateTime? result = await showDatePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        initialDate: DateTime.now(),
      );

      if (result != null) {
        fieldInputController.text = formatter.format(result);
      }
    }

    switch (type) {
      case 'string':
        return TextFormField(
          controller: fieldInputController,
          decoration: InputDecoration(labelText: name),
        );
      case 'number':
        {
          fieldInputController.text = "0.00";
          return TextFormField(
            controller: fieldInputController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(labelText: name),
          );
        }
      case 'bool':
        {
          fieldInputController.text = ref.watch(creditDebit).toString();
          return Column(
            children: <Widget>[
              Align(alignment: Alignment.centerLeft, child: Text(name)),
              Row(
                children: <Widget>[
                  Text("True: "),
                  Radio<bool>(
                    value: true,
                    groupValue: ref.watch(creditDebit),
                    onChanged: (value) {
                      ref.read(creditDebit.notifier).value = value!;
                    },
                  ),
                  Text("False: "),
                  Radio<bool>(
                    value: false,
                    groupValue: ref.watch(creditDebit),
                    onChanged: (value) {
                      ref.read(creditDebit.notifier).value = value!;
                    },
                  ),
                ],
              )
            ],
          );
        }

      case 'timestamp':
        {
          fieldInputController.text = formatter.format(DateTime.now());
          return TextFormField(
            controller: fieldInputController,
            decoration: InputDecoration(labelText: 'Date'),
            onTap: selectDate,
          );
        }

      default:
        return Container();
    }
  }
}
