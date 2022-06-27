# seeder

Transaction generator for AML Cloud users.

Those who define AML rules need test data samples to test rules on.

The purpose of this app is to configure individual entities (for instance a bank customer or a superfund member) with paramters of their income and spending. Based on those parameters transactions should be generated.

Intended features:
- Show list of entities
- Configure individual entity parameters: income, min balance, recurring and random spending
- Define transaction range parameters: period
- Define additional specific transactions (for rule testing)
- See entity transactions
- Combine entities' transaction into sets
- Export transactions into CSV (to be imported into amlcloud.io)

This repo is only the front-end of the app and it is built with Flutter backed by Firebase Firestore.

Another goal of the project is educational, therefore there is an embeded sandbox for Widget testing added to it for better efficiency (experimental).


## Flutter

If you are new to Flutter, these resources will get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase Firestore

The support for Firestore was added using this guide:
https://firebase.google.com/docs/flutter/setup?platform=web


