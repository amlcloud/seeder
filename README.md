# seeder

Transaction generator for AML Cloud users.

Those users (Compliance Specialists) who define AML rules need test data samples to test rules on.

The purpose of this app is to configure individual entities (for instance a bank customer or a superfund member) with paramters of their income and spending. Based on those parameters transactions should be generated.

Intended features:
- Show list of en
- Configure individual entity parameters: income, min balance, recurring and random spending
- Define transaction range parameters: period
- Define additional specific transactions (for rule testing)
- See entity transactions
- Combine entities' transaction into batches
- Export transactions into CSV (to be imported into amlcloud.io)

This repo is only the front-end of the app and it is built with Flutter backed by Firebase Firestore. (Another repository will be created to define server functions, which will serve as a back-end of the application).

Another goal of the project is educational, therefore there is an embeded sandbox for Widget testing added to it for better efficiency (experimental).


## Flutter

If you are new to Flutter, these resources will get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Remember, in the context of this project we are using Flutter for Web only!

## Riverpod

For all state management (data binding and interactivity) we will be using https://riverpod.dev/

If you are new to it, please have a read through the website and the tutorial here: [Flutter State Management with Riverpod: The Essential Guide](https://codewithandrea.com/articles/flutter-state-management-riverpod/)

## Firebase Firestore

The support for Firestore was added using this guide:
https://firebase.google.com/docs/flutter/setup?platform=web


## Transactions

// This sudo code explains how transactions look for the entity:
// 
// name: 'John Smith'
// account: 1234234
// bank: 'NAB'
// bsb: '12342'
//

// choose describes the probability of a transaction
// with its first parameter (in this case transaction_type) 
// being the value of its second parameter 
// (in this case 'CREDIT' - 10-20% probability,
//               'DEBIT' - 90-80% probability
// )                  
transaction_type: 

category:
employed professional:
      cash deposit: 0.1,
      cash deposit third party: 0.1,
      interest: 0.00001,
      cheque deposit: 0.00001,
      direct credit: 0.6, // salary for stable employer people
      third party transfer: 0.2 // centerlink falls under this.
      
UNEMPLOYED/STUDENT
cash deposit: 0.2,
cash deposit third party: 0.2,
interest: 0.001,
cheque deposit: 0.001,
direct credit: 0.1,
third party transfer: 0.5  //centerlink falls under this.
  for unemployed could be up to 50% of all income
  also used for casual or one off jobs
  this payments mostly go via NPP, but it will not be visible
