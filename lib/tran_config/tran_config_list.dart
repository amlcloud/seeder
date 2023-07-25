import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/firestore.dart';
import 'package:seeder/controls/group.dart';
import 'package:seeder/entity/entity_list_item.dart';
import 'package:seeder/entity/filter_my_entities.dart';
import 'package:seeder/providers/firestore.dart';
import 'package:seeder/state/generic_state_notifier.dart';
import 'package:seeder/tran_config/tran_config.dart';
import 'package:widgets/col_stream_widget.dart';

final activeSort =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class TranConfigList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Column(
            children: [
              // Row(children: [
              //   Text('sort by: '),
              //   DropdownButton<String>(
              //     value: ref.watch(activeSort) ?? 'id',
              //     icon: const Icon(Icons.arrow_downward),
              //     elevation: 16,
              //     // style: const TextStyle(color: Colors.deepPurple),
              //     underline: Container(
              //       height: 2,
              //       // color: Colors.deepPurpleAccent,
              //     ),
              //     onChanged: (String? newValue) {
              //       ref.read(activeSort.notifier).value = newValue;
              //     },
              //     items: <String>['name', 'id', 'time Created']
              //         .map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value.toUpperCase()),
              //       );
              //     }).toList(),
              //   )
              // ]),
              // FilterMyEntities(),
            ],
          ),
          Group(
              child: ColStreamWidget<Widget>(
            colSPfiltered2('periodicConfig', queries: [
              // const QueryParam2('type', isEqualTo: 'shared'),
              // const QueryParam2('isStartup', isEqualTo: true)
            ]),
            (c, snap, items) => ListView(
                padding: EdgeInsets.zero, shrinkWrap: true, children: items),
            (context, entity) => TranConfig(entity),
          ))
        ],
      );
}

// class ColStreamWidgetEx<ItemWidgetType> extends ConsumerWidget {
//   final Widget Function(
//       BuildContext context, QS col, List<ItemWidgetType> items) builder;
//   final ItemWidgetType Function(BuildContext context, DS doc) itemBuilder;
//   final AutoDisposeStreamProvider<QS> colStreamProvider;
//   final Widget? loader;
//   const ColStreamWidgetEx(
//     this.colStreamProvider,

//     this.builder,
//     this.itemBuilder, {
//     super.key,
//     this.loader,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) =>
//       ref.watch(colStreamProvider).when(
//           data: (col) {
//             return builder(context, col,
//                 col.docs.map((doc) => itemBuilder(context, doc)).toList());
//           },
//           loading: () => loader == null ? Container() : loader!,
//           error: (e, s) => ErrorWidget(e));
// }
