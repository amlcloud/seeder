import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldSlider extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String field;
  final double maxValue;
  const DocFieldSlider(this.docRef, this.field, this.maxValue, {Key? key})
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
              Slider(
                value: currentSliderValue,
                max: widget.maxValue,
                divisions: widget.maxValue.round(),
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
