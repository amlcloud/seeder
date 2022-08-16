import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeder/dialogs/common_config_field.dart';

class AddRandomConfig extends ConsumerWidget {
  /// TextEditingController for Common
  final String entityId;
  const AddRandomConfig(this.entityId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComonConfig("randomConfig", entityId);
  }
}
