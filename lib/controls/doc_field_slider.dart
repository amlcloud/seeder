import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldSlider extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String field;
  final double maxValue;
  final bool isEditable;
  const DocFieldSlider(this.docRef, this.field, this.maxValue, this.isEditable,
      {Key? key})
      : super(key: key);
  @override
  DocFieldSliderState createState() => DocFieldSliderState();
}

class DocFieldSliderState extends ConsumerState<DocFieldSlider> {
  double currentSliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return ref.watch(docSP(widget.docRef.path)).when(
        loading: () => Container(),
        error: (e, s) => Container(),
        data: (Docfield) {
          return Slider(
            value: currentSliderValue,
            max: widget.maxValue,
            divisions: widget.maxValue.round(),
            label: currentSliderValue.round().toString(),
            onChanged: widget.isEditable
                ? (double values) {
                    setState(() {
                      currentSliderValue = values;
                    });
                  }
                : null,
            onChangeEnd: widget.isEditable
                ? (double endValues) {
                    widget.docRef.set({
                      widget.field: endValues.toInt(),
                    }, SetOptions(merge: true));
                  }
                : null,
          );
        });
  }
}
