import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/state/generic_state_notifier.dart';

final controlerList = StateNotifierProvider<
        GenericStateNotifier<List<TextEditingController>>,
        List<TextEditingController>>(
    (ref) => GenericStateNotifier<List<TextEditingController>>([]));
final fieldLabel =
    StateNotifierProvider<GenericStateNotifier<List<String>>, List<String>>(
        (ref) => GenericStateNotifier<List<String>>([]));

class FieldAdder extends ConsumerWidget {
  const FieldAdder(this.fieldList);
  final List<String> fieldList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref.read(controlerList.notifier).value.clear();
    //ref.read(fieldLabel.notifier).value.clear();
    return Column(
        children: fieldList.map((element) {
      TextEditingController controller = TextEditingController();
      ref.read(controlerList.notifier).value.add(controller);
      ref.read(fieldLabel.notifier).value.add(element);
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: element),
      );
    }).toList());
    //return Container();
  }
}
