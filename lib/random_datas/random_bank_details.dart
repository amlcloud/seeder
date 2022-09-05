import 'dart:math' as math;

randomBank() {
  const bank = [
    'WBC',
    'CBA',
    'ANZ',
    'ADV',
    'BSA',
    'MBL',
    'NAB',
    'PIB',
    'BOM',
    'MCU',
    'HBA',
    'BOT',
    'SUN',
    'CBL',
    'APO',
    'CUS',
    'RBA',
    'CST',
    'CRU',
    'BAL',
    'OCB',
    'BQL',
    'T&C',
    'ASL',
    'STG',
    'BOC',
    'BTA',
    'TBT',
    'CMB',
    'BPS',
    'BWA',
    'BNP',
    'CTI',
    'DBA',
    'ADL'
  ];

  var rand = math.Random().nextInt(bank.length);
  return bank[rand];
}

randomRef() {
  List refList = ["ATM", "Branch"];
  var rand = math.Random().nextInt(refList.length);
  return refList[rand];
}

randomAccount() {
  return (math.Random().nextInt(899999999) + 1000000000).round().toString();
}

randomBSB() {
  return (math.Random().nextInt(989999) + 10000).round().toString();
}
