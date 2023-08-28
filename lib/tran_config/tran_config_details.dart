import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:providers/generic.dart';
import 'package:seeder/controls/doc_field_text_edit2.dart';
import 'package:widgets/doc_field_drop_down.dart';
import 'package:widgets/doc_field_text_field.dart';
import 'package:widgets/doc_stream_widget.dart';

import '../controls/group.dart';
import '../providers/firestore.dart';

class TranConfigDetails extends ConsumerWidget {
  final DR tranConfigRef;

  TranConfigDetails(this.tranConfigRef);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(children: [
        Text('Tran Config Details'),
        DocFieldTextField(tranConfigRef, 'description'),
        // DocFieldRadioGroup(tranConfigRef, 'direction', ['credit', 'debit'],
        //     (context, items) {
        //   return Group(
        //       child: Column(children: <Widget>[
        //     Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text('Choose Transaction type')),
        //     Row(children: items)
        //   ]));
        // }, (context, index, name, radioWidget) {
        //   return Row(children: [
        //     radioWidget,
        //     Text(name.toString()),
        //   ]);
        // }),

        DocEditor(
          tranConfigRef,
          schema: {
            'direction': {
              'type': 'select',
              'options': ['credit', 'debit']
            },
            'account': {
              'type': 'string',
            },
            'bsb': {
              'type': 'string',
            },
            'bank': {
              'type': 'string',
            },
            'name': {
              'type': 'string',
            },
            'category': {
              'type': 'select',
              'options': [
                'direct deposit',
                'cash withdrawal',
                'transfer',
                'fee',
                'interest',
                'other'
              ]
            },
            'maxAmount': {
              'type': 'number',
            },
            'minAmount': {
              'type': 'number',
            },
            'period': {
              'type': 'select',
              'options': ['week', 'month', 'quarter']
            },
            'reference': {
              'type': 'string',
            },
          },
          divider: SizedBox(
            height: 8,
          ),
        ),
      ]);
}

class DocFieldRadioGroup<T> extends ConsumerWidget {
  final DR docRef;
  final String fieldName;
  final List<T> items;
  final Widget Function(BuildContext context, List<Widget> items) builder;
  final Widget Function(
      BuildContext context, int index, T name, Widget radioWidget) itemBuilder;

  DocFieldRadioGroup(
      this.docRef, this.fieldName, this.items, this.builder, this.itemBuilder);

  @override
  Widget build(BuildContext context, WidgetRef ref) => DocStreamWidget(
      docSP(docRef.path),
      (context, doc) => builder(
          context,
          items.asMap().entries.map((entry) {
            int index = entry.key;
            return itemBuilder(
                context,
                index,
                entry.value,
                Radio<T>(
                  value: items[index],
                  groupValue: doc.data()?[fieldName],
                  onChanged: (value) {
                    docRef.set({fieldName: value}, SetOptions(merge: true));
                  },
                ));
          }).toList()));
}

class DocEditor extends ConsumerWidget {
  final DR docRef;
  final Map<String, dynamic>? schema;
  final bool capitalizeLabels;
  final Widget divider;
  final bool shrinkWrap;

  DocEditor(this.docRef,
      {key,
      this.schema,
      this.capitalizeLabels = true,
      this.divider = const Divider(),
      this.shrinkWrap = true})
      : super(key: key);

  bool distinct(Map<String, dynamic>? b, Map<String, dynamic>? a) {
    Map<String, dynamic> before = b ?? {};
    Map<String, dynamic> after = a ?? {};

    Set<String> beforeKeys = before.keys.toSet();
    Set<String> afterKeys = after.keys.toSet();

    return beforeKeys.difference(afterKeys).isEmpty &&
        afterKeys.difference(beforeKeys).isEmpty;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => DocStreamWidget(
          docSPdistinct(
              DocParam(docRef.path, (b, a) => distinct(a.data(), b.data()))),
          (context, doc) {
        print('docEditor: ${doc.data()}');
        return !doc.exists
            ? Container()
            : schema != null
                ? ListView.separated(
                    shrinkWrap: shrinkWrap,
                    separatorBuilder: (context, index) => divider,
                    itemCount: schema!.keys.length,
                    itemBuilder: (context, index) {
                      final label = schema!.keys.elementAt(index);
                      final def = schema![label];
                      print('type: ${def}');
                      return
                          // Container(
                          //     color: Colors.purple,
                          //     child:
                          Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // code to change:
                          // Flexible(child: Text(label)),
// make the label start with a capital letter based on the parameter provided to the widget
                          Flexible(
                              child: Text(
                                  capitalizeLabels
                                      ? label[0].toUpperCase() +
                                          label.substring(1)
                                      : label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context).hintColor))),
                          Text(':',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).hintColor)),

                          SizedBox(width: 8),
                          Expanded(child: buildInputField(label, def)),
                        ],
                      );
                    },
                  )
                : Column(
                    children: doc
                        .data()!
                        .entries
                        .map((e) =>
                            Row(mainAxisSize: MainAxisSize.max, children: [
                              Flexible(
                                  child: Text(e.key + ':',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .hintColor))),
                              SizedBox(width: 8),
                              Flexible(
                                  child: e.value is String
                                      ? DocFieldTextField2(docRef, e.key,
                                          key: Key(e.key))
                                      : e.value is Timestamp
                                          ? Text(e.value.toDate().toString())
                                          : e.value is bool
                                              ? Checkbox(
                                                  value: e.value,
                                                  onChanged: (value) {
                                                    docRef.set({
                                                      e.key: value
                                                    }, SetOptions(merge: true));
                                                  })
                                              : e.value is num
                                                  ? DocFieldTextField2(
                                                      docRef, e.key,
                                                      key: Key(e.key),
                                                      keyboardType:
                                                          TextInputType.number)
                                                  : Text(e.value.toString())),
                            ]))
                        .toList());
      });

  Widget buildInputField(String key, Map<String, dynamic> def) {
    final type = def['type'];
    if (type == "string") {
      return DocFieldTextField2(
        docRef,
        key,
      );
    } else if (type == "number") {
      return DocFieldTextField2(
        docRef,
        key,
        type: DocFieldTextField2Type.Number,
      );
    } else if (type == "boolean") {
      return DocFieldRadioGroup(docRef, key, [true, false], (context, items) {
        return Group(child: Row(children: items));
      }, (context, index, name, radioWidget) {
        return Row(children: [
          radioWidget,
          Text(name.toString()),
        ]);
      });
    } else if (type == "select") {
      return DocFieldDropDown3(
          docRef,
          key,
          (def['options'] as List<String>)
              .map((option) =>
                  DropdownMenuItem<String>(value: option, child: Text(option)))
              .toList());
    } else if (type == "timestamp") {
      // show date picker for user to select the date
      return DocFieldDatePicker(docRef, key);
    }
    // TODO: Add cases for other data types.
    // We're only considering String and Number for simplicity.
    return Container();
  }
}

/// DocFieldDatePicker is the widget that lets a user select a date.
/// It uses the [showDatePicker] method to show the date picker.
/// The selected date is saved to the Firestore document.
///
class DocFieldDatePicker extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final InputDecoration? decoration;
  final int saveDelay;
  final bool showSaveStatus;
  final bool enabled;
  final Function(String)? onChanged;
  final TextStyle? style;
  final bool canAddLines;
  final List<TextInputFormatter>? inputFormatters;

  DocFieldDatePicker(this.docRef, this.field,
      {this.decoration,
      this.saveDelay = 1000,
      this.showSaveStatus = true,
      this.enabled = true,
      this.onChanged,
      this.style,
      this.canAddLines = false,
      this.inputFormatters});

  @override
  _DocFieldDatePickerState createState() => _DocFieldDatePickerState();
}

class _DocFieldDatePickerState extends ConsumerState<DocFieldDatePicker> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101));
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
          widget.docRef.set({widget.field: Timestamp.fromDate(picked)},
              SetOptions(merge: true));
        }
      },
      child: Container(
        child: Text(
          _selectedDate == null
              ? 'Select Date'
              : Jiffy(_selectedDate).format('dd MMM yyyy'),
          //DateFormat('yyyy-MM-dd').format(_selectedDate!),
          style: widget.style,
        ),
      ),
    );
  }
}

enum DocFieldTextField2Type { Text, Number }

class DocFieldTextField2 extends ConsumerStatefulWidget {
  final DocumentReference<Map<String, dynamic>> docRef;
  final String field;
  final InputDecoration? decoration;
  final DocFieldTextField2Type type;
  final int minLines;
  final int maxLines;
  final bool debugPrint;
  final bool showSaveStatus;
  final int saveDelay;
  final bool enabled;
  TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool canAddLines;
  final TextStyle? style;
  List<TextInputFormatter>? inputFormatters;

  // const DocFieldTextField2(this.docRef, this.field,
  //     {this.decoration,
  //     this.type = DocFieldTextField2Type.Text,
  //     this.minLines = 1,
  //     this.maxLines = 1,
  //     TextInputType? keyboardType,
  //     this.saveDelay = 1000,
  //     this.showSaveStatus = true,
  //     this.debugPrint = false,
  //     this.enabled = true,
  //     this.onChanged = null,
  //     this.canAddLines = false,
  //     this.style,
  //     List<TextInputFormatter>? inputFormatters,
  //     Key? key})
  //     : keyboardType = type == DocFieldTextField2Type.Number
  //           ? TextInputType.number
  //           : keyboardType,
  //       inputFormatters = type == DocFieldTextField2Type.Number
  //           ? [FilteringTextInputFormatter.digitsOnly]
  //           : inputFormatters,
  //       super(key: key);

  DocFieldTextField2(this.docRef, this.field,
      {this.decoration,
      this.type = DocFieldTextField2Type.Text,
      this.minLines = 1,
      this.maxLines = 1,
      TextInputType? keyboardType,
      this.saveDelay = 1000,
      this.showSaveStatus = true,
      this.debugPrint = false,
      this.enabled = true,
      this.onChanged = null,
      this.canAddLines = false,
      this.style,
      List<TextInputFormatter>? inputFormatters,
      Key? key})
      : super(key: key) {
    if (type == DocFieldTextField2Type.Number) {
      this.keyboardType = TextInputType.number;
      this.inputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        // FilteringTextInputFormatter.digitsOnly
      ];
    } else {
      this.keyboardType = keyboardType;
      this.inputFormatters = inputFormatters;
    }
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      DocFieldTextEditState2();
}

class DocFieldTextEditState2 extends ConsumerState<DocFieldTextField2> {
  Timer? descSaveTimer;
  StreamSubscription? sub;
  final TextEditingController ctrl = TextEditingController();
  final SNP status = snp<String>('saved!');
  int currentLinesCount = 1;

  @override
  void initState() {
    super.initState();
    currentLinesCount = widget.minLines;
    sub = widget.docRef.snapshots().listen((event) {
      if (!event.exists) return;
      if (widget.debugPrint) {
        print(
            'DocFieldTextEditState ${widget.field} received ${event.data()![widget.field]}');
      }
      if (event.data() != null &&
          ctrl.text != event.data()![widget.field] &&
          event.data()![widget.field] != null) {
        ctrl.text = event.data()![widget.field].toString();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (descSaveTimer != null && descSaveTimer!.isActive) {
      descSaveTimer!.cancel();
    }
    if (sub != null) {
      if (widget.debugPrint) {
        print('DocFieldTextEditState sub cancelled');
      }
      sub!.cancel();
      sub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
            inputFormatters: widget.inputFormatters,
            decoration: widget.decoration,
            controller: ctrl,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            style: widget.style,
            minLines: currentLinesCount,
            maxLines: widget.maxLines,
            onChanged: (v) {
              ref.read(status.notifier).value = 'changed';
              if (descSaveTimer != null && descSaveTimer!.isActive) {
                descSaveTimer!.cancel();
              }
              descSaveTimer = Timer(
                  Duration(milliseconds: widget.saveDelay), () => saveValue(v));
              if (widget.onChanged != null) widget.onChanged!(v);

              // setState(() {
              //   currentLinesCount = !widget.canAddLines
              //       ? this.currentLinesCount
              //       : (v.split('\n').length + 1 > widget.maxLines
              //           ? widget.maxLines
              //           : v.split('\n').length + 1);
              // });
              setState(() {
                final textLinesCount = v.split('\n').length + 1;
                if (textLinesCount < widget.minLines) {
                  currentLinesCount = widget.minLines;
                } else if (textLinesCount > widget.maxLines) {
                  currentLinesCount = widget.maxLines;
                } else {
                  currentLinesCount = textLinesCount;
                }

                // currentLinesCount = !widget.canAddLines
                //     ? currentLinesCount
                //     : textLinesCount > widget.maxLines
                //         ? widget.maxLines
                //         : textLinesCount < widget.minLines
                //             ? widget.minLines
                //             : textLinesCount;
              });
            },
            onSubmitted: (v) {
              if (descSaveTimer != null && descSaveTimer!.isActive) {
                descSaveTimer!.cancel();
              }
              saveValue(v);
            }),
        if (widget.showSaveStatus)
          Positioned(
              right: 0,
              top: 0,
              child: Icon(
                ref.watch(status) == 'saved'
                    ? Icons.check_circle
                    : (ref.watch(status) == 'saving'
                        ? Icons.save
                        : (ref.watch(status) == 'error'
                            ? Icons.error
                            : Icons.edit)),
                color: Colors.green,
                size: 10,
              ))
      ],
    );
  }

  void saveValue(String inputValue) async {
    ref.read(status.notifier).value = 'saving';
    if (widget.debugPrint) {
      print('status: ${ref.read(status.notifier).value}');
    }
    try {
      dynamic valueToSave;

      if (widget.type == DocFieldTextField2Type.Number) {
        // int? numberValue = int.tryParse(inputValue);
        double? numberValue = double.tryParse(inputValue);
        if (numberValue != null) {
          valueToSave = numberValue;
        } else {
          print('Invalid number');
          return;
        }
      } else {
        valueToSave = inputValue;
      }
      await widget.docRef
          .set({widget.field: valueToSave}, SetOptions(merge: true));
    } catch (e) {
      if (widget.debugPrint) {
        print('error saving: ${e.toString()}');
      }
      ref.read(status.notifier).value = 'error';
    }

    ref.read(status.notifier).value = 'saved';
    if (widget.debugPrint) {
      print('status: ${ref.read(status.notifier).value}');
    }
  }
}
