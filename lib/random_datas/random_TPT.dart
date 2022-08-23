import 'dart:math' as math;

randomTPTF() {
  final  List tpt = [
    'loan',
    'gift',
    'rent',
    'bill',
    'lunch',
    'coffee',
    'food',
    'dinner',
    'thank you',
    'love you',
    'chair',
    'bike',
    'gumtree',
    'facebook market',
  ];
  var rand = math.Random().nextInt(tpt.length);
  return tpt[rand];
}
