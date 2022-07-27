import 'package:flutter/material.dart';
import 'package:seeder/controls/group.dart';

class SpecificConfig extends StatelessWidget {
  const SpecificConfig({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Group(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                )),
            child: Column(children: [
              Expanded(child: Text('specific trn')),
              Expanded(
                  child: Column(children: [
                Column(
                  children: [
                    Card(
                        child: ListTile(
                      leading: Switch(
                          value:
                              true, //ref.watch(isMineBatchNotifierProvider) ?? false,
                          onChanged: (value) {
                            //ref.read(isMineBatchNotifierProvider.notifier).value = value;
                          }),
                      title: Text('cash withdrawal'),
                      subtitle: Slider(
                        value: 10, //_currentSliderValue,
                        max: 100,
                        divisions: 5,
                        // label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          // setState(() {
                          //   _currentSliderValue = value;
                          // });
                        },
                      ),
                      trailing:
                          IconButton(icon: Icon(Icons.add), onPressed: () {}),
                    )),
                    IconButton(icon: Icon(Icons.add), onPressed: () {}),
                  ],
                )
              ]))
            ])));
  }
}
