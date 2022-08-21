import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/providers/firestore.dart';

class DocFieldRangeSlider extends ConsumerStatefulWidget {
  final DocumentReference docRef;
  final String minfield;
  final String maxfield;
  final double maxValue;
  final double minValue;
  //final Map mapData;
  const DocFieldRangeSlider(
      this.docRef,
      this.minfield,
      this.maxfield,
      //this.mapData,
      this.minValue,
      this.maxValue,
      {Key? key})
      : super(key: key);

  @override
  DocFieldRangeSliderState createState() => DocFieldRangeSliderState();
}

class DocFieldRangeSliderState extends ConsumerState<DocFieldRangeSlider> {
  RangeLabels labels = RangeLabels('1', "100");
  RangeValues currentRangeValues = const RangeValues(0, 10000);

  // var minvalue = 0.0;
  // var maxvalue = 0.0;
  @override
  void initState() {
    super.initState();
    RangeValues setrange = RangeValues(widget.minValue, widget.maxValue);
    setState(() {
      currentRangeValues = setrange;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ref.watch(docSP(widget.docRef.path)).when(
        loading: () => Container(),
        error: (e, s) => Container(),
        data: (Docfield) => 
                RangeSlider(
                  values: currentRangeValues,
                  min: widget.minValue,
                  max: widget.maxValue,
                  labels: RangeLabels(
                    "\$${currentRangeValues.start.round().toString()}",
                    "\$${currentRangeValues.end.round().toString()}",
                  ),
                  divisions: widget.maxValue.round(),
                  onChanged: (RangeValues values) {
                    setState(() {
                      currentRangeValues = values;
                    });
                  },
                  onChangeEnd: (RangeValues endValues) {
                    widget.docRef.set({
                      widget.minfield: endValues.start.toInt(),
                      widget.maxfield: endValues.end.toInt(),
                    }, SetOptions(merge: true));
                  },
            ));
  }
}
