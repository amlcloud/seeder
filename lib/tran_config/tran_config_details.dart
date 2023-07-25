import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        DocFieldRadioGroup(tranConfigRef, 'direction', ['credit', 'debit'],
            (context, items) {
          return Group(
              child: Column(children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Choose Transaction type')),
            Row(children: items)
          ]));
        }, (context, index, name, radioWidget) {
          return Row(children: [
            radioWidget,
            Text(name.toString()),
          ]);
        }),
        //DocEditor(tranConfigRef)
        // DocEditor(tranConfigRef,
        // {
        //   // 'direction':
        // })
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

  DocEditor(this.docRef, {this.schema});

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
                ? ListView.builder(
                    itemCount: schema!.keys.length,
                    itemBuilder: (context, index) {
                      final key = schema!.keys.elementAt(index);
                      final def = schema![key];
                      print('type: ${def}');
                      return Row(
                        children: <Widget>[
                          Flexible(child: Text(key)),
                          SizedBox(width: 8),
                          Flexible(child: buildInputField(key, def)),
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
    }
    // TODO: Add cases for other data types.
    // We're only considering String and Number for simplicity.
    return Container();
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
