import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';
import 'package:seeder/common.dart';

// TODO: check if this person has been paid on that day
// TODO: where should i put this function...

void generateSalary(entityId) async{

  double currentBalance = await FirebaseFirestore.instance
            .collection('entity/${entityId}/transaction')
            .orderBy('t', descending: true)
            .limit(1)
            .get()
            .then((QuerySnapshot querySnapshot)=> double.parse(querySnapshot.docs.first['balance']));
            
  FirebaseFirestore.instance.collection('entity/${entityId}/config')
            .get()
            .then((value){
              value.docs.forEach((element) {
                if(element.data()['type']=="CREDIT"){
                  final payDays = element.data()['days'];
                  payDays.forEach((day){if(day == Jiffy().date){print(day);}});
                }
              });
            });

            

  //   FirebaseFirestore.instance
  //               .collection('entity/${entityId}/transaction')
  //               .add({
  //             'amount': salaryAmount,
  //             'balance':(currentBalance + salaryAmount).toString(),
  //             'ben_name': "Beneficiary",
  //             'reference': "Example Salary Reference",
  //             'rem_name': "Company",
  //             't': Jiffy().dateTime,
  //             'day': Jiffy().format(DATE_FORMAT),
  //           });
  // }
}