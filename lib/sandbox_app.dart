import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/generic.dart';
import 'package:seeder/tran_config/tran_config_details.dart';

class SandboxApp extends StatelessWidget {
  SandboxApp({Key? key}) : super(key: key);

  final SNP<Map<String, dynamic>?> _nsp = snp<Map<String, dynamic>?>(null);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [],
      child: DefaultTabController(
        length: 3, //MyAppBar.tabs.length,
        child: MaterialApp(
            theme: ThemeData.light(), // darkTheme,
            darkTheme: ThemeData.dark(), // darkTheme,
            themeMode: ThemeMode.dark,
            title: "SANDBOX!",
            home: Scaffold(
                body: SizedBox(
                    width: 800,
                    height: 600,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DocEditor(
                        key: ValueKey('test'),
                        kDB.doc('test/1'),
                        schema: {
                          'name': {
                            'type': 'string',
                          },
                          'age': {
                            'type': 'number',
                          },
                          'single': {
                            'type': 'boolean',
                          },
                          'dob': {
                            'type': 'timestamp',
                          },
                          'gender': {
                            'type': 'select',
                            'options': ['male', 'female', 'other']
                          }
                        },
                        divider: SizedBox(
                          height: 8,
                        ),
                      ),
                    )
                    // MatchesWidget(kDB.doc(
                    //     '/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/hBjBqqeDDH0d27uNDfpb'))
                    //     InvestigationWidget(
                    //   kDB.doc(
                    //       '/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/7KwD1DNdCYARJmjYaA5w'),
                    //   kDB.doc(
                    //       "/user/AA4JoO0fvSWtTxeROjRhTUYMIY52/case/7KwD1DNdCYARJmjYaA5w/search/Abd al-Rahman bin 'Amir al-Nu'aymi"),
                    // )
                    // Text('hello')
                    //CasesPage()
                    //ListDetails('api.trade.gov', null)
                    //ListDetails('api.trade.gov', _nsp.notifier)
                    ))),
      ),
    );
  }
}
