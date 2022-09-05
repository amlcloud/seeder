import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seeder/entity/data_export.dart';
import 'package:seeder/providers/firestore.dart';
import "package:universal_html/html.dart" as html;

class DataExportButton extends ConsumerWidget {
  final String entityId;
  final String currentAuthor = FirebaseAuth.instance.currentUser!.uid;

  DataExportButton(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docFP('entity/${entityId}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (entityDoc) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: entityDoc.data()!['author'] == currentAuthor
                          ? () {
                              generateExportCSV(ref, entityId);
                              Fluttertoast.showToast(msg: 'CSV exported');
                            }
                          : null,
                      child: Text('Export CSV')),
                  SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: entityDoc.data()!['author'] == currentAuthor
                          ? () {
                              generateClipboardCSV(ref, entityId);
                              Fluttertoast.showToast(
                                  msg: 'Copied to clipboard');
                            }
                          : null,
                      child: Text('Copy to clipboard'))
                ],
              ));
}
