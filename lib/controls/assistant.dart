import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class assistant extends StatefulWidget {
  @override
  asstState createState() {
    return asstState();
  }
}

class asstState extends State {
  bool isVisible = false;

  void showAsst() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                      visible: isVisible,
                      child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: FractionallySizedBox(
                                heightFactor: 0.6,
                                widthFactor: 0.2,
                                child: Column(children: [
                                  Text("This is your website assistant!",
                                      style: TextStyle(fontSize: 20)),
                                  Text("Put assistant content stuff here",
                                      style: TextStyle(fontSize: 20))
                                ])),
                          ))))),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      textStyle: TextStyle(fontSize: 60),
                      //minimumSize: Size.fromHeight(50),
                    ),
                    onPressed: showAsst,
                    child: Text("?")),
              ))
        ],
      ),
    );
  }
}
