import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldSlider extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String field;
  final Map mapData;
  const DocFieldSlider(this.docRef, this.field, this.mapData, {Key? key})
      : super(key: key);
  @override
  DocFieldRangeSliderState createState() => DocFieldRangeSliderState();
}
class DocFieldRangeSliderState extends ConsumerState<DocFieldSlider> {
  double currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return ref.watch(docSP(widget.docRef.path)).when(
        loading: () => Container(),
        error: (e, s) => Container(),
        data: (Docfield) {
          return Column(
            children: <Widget>[
              Text(
                  "Frequency: ${Docfield.data()!['frequency']} days a ${Docfield.data()!['period']} "),
              Slider(
                value: currentSliderValue,
                max: widget.mapData['period'] == 'Week'
                    ? 7
                    : widget.mapData['period'] == 'Month'
                        ? 28
                        : 84,
                divisions: 100,
                label: currentSliderValue.round().toString(),
                onChanged: (double values) {
                  setState(() {
                    currentSliderValue = values;
                  });
                },
                onChangeEnd: (double endValues) {
                  widget.docRef.set({
                    widget.field: endValues.toInt(),
                  }, SetOptions(merge: true));
                },
              )
            ],
          );
        });
  }
}
