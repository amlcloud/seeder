import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seeder/main.dart';

class DevFrame extends StatelessWidget {
  const DevFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Text Widget 1'),
            ),
            ListTile(
              title: Text('Text Widget 1'),
            )
          ],
        ));
  }
}

class DevFrameLauncher extends StatefulWidget {
  final Widget child;

  const DevFrameLauncher({Key? key, required this.child}) : super(key: key);

  @override
  State<DevFrameLauncher> createState() => _DevFrameLauncherState();
}

class _DevFrameLauncherState extends State<DevFrameLauncher> {
  OverlayEntry? _overlayEntry;
  bool _isFirstInsert = true;

  @override
  Widget build(BuildContext context) => RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          print('enter pressed');
          //print('enter ${RawKeyboard.instance.keysPressed}');
          if (RawKeyboard.instance.keysPressed
                  .contains(LogicalKeyboardKey.metaLeft) ||
              RawKeyboard.instance.keysPressed
                  .contains(LogicalKeyboardKey.metaRight)) {
            //print('hotkey preseed ${RawKeyboard.instance.keysPressed}');

            if (_overlayEntry != null) {
              print('remove overlay');
              _removeOverlay();
            } else {
              print('insert overlay');
              _insertOverlay(context);
            }
          }
        }
      },
      child: LayoutBuilder(builder: (context, constraints) {
        // WidgetsBinding.instance.addPostFrameCallback(
        //     (_) => _isFirstInsert ? _insertOverlay(context) : {});
        return widget.child;
      }));

  void _removeOverlay() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _insertOverlay(BuildContext context) {
    _isFirstInsert = false;

    if (_overlayEntry != null) return;

    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && Overlay.of(context) != null) {
      var size = renderBox.size;
      //var offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
                left: size.width - 400,
                top: 60,
                bottom: 0,
                width: 400,
                child: Material(elevation: 4.0, child: DevFrame()),
              ));
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }
}
