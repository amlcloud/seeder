import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/entity/config/periodic_config.dart';
import 'package:seeder/entity/config/random_config.dart';
import 'package:seeder/entity/config/specific_config.dart';
import 'package:seeder/entity/generate_transactions_button.dart';

class EntityConfig extends ConsumerStatefulWidget {
  final String entityId;
  const EntityConfig(this.entityId);

  @override
  EntityConfigState createState() => EntityConfigState();
}

class EntityConfigState extends ConsumerState<EntityConfig>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Periodic",
            ),
            Tab(
              text: "Random",
            ),
            Tab(
              text: "Specific",
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.65,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: <Widget>[
              PeriodicConfig(widget.entityId),
              RandomConfig(widget.entityId),
              SpecificConfig(),
            ],
          ),
        ),
        GenerateTransactions(widget.entityId),
      ],
    );
  }
}
