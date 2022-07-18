import 'package:flutter/material.dart';

class RandomConfig extends StatelessWidget {
  const RandomConfig({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Column(
          children: [
            Expanded(child: Text('random trn')),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                  child: Column(
                children: [
                  Text('available periodic templates'),
                  Column(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('monthly salary'),
                        subtitle: Text('\$2000-\$10000'),
                        trailing:
                            IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('weekly salary'),
                        subtitle: Text('\$500-\$1000'),
                        trailing:
                            IconButton(icon: Icon(Icons.add), onPressed: () {}),
                      )),
                      IconButton(icon: Icon(Icons.add), onPressed: () {}),
                    ],
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text('selected periodic templates'),
                  Column(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text('Spotify subscription'),
                        subtitle: Text('\$12.95, monthly on 15th'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('gas bill'),
                        subtitle: Text('~\$434, quarterly on 1st'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      )),
                      Card(
                          child: ListTile(
                        title: Text('fortnightly salary'),
                        subtitle: Text('~\$434, fortnightly on 11th'),
                        trailing: IconButton(
                            icon: Icon(Icons.close), onPressed: () {}),
                      ))
                    ],
                  )
                ],
              )),
            ])
          ],
        ));
  }
}
