import 'package:cupertino_rrect/cupertino_rrect.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Contents(),
      ),
    );
  }
}

class Contents extends StatefulWidget {
  const Contents({
    super.key,
  });

  @override
  State<Contents> createState() => _ContentsState();
}

enum Mode {
  standard,
  cupertino,
}

class _ContentsState extends State<Contents>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  Mode _mode = Mode.cupertino;
  bool _showBorder = true;

  @override
  Widget build(BuildContext context) {
    const int count = 200;
    final borderSide = _showBorder
        ? BorderSide(
            color: Colors.red.withOpacity(_animation.value),
            width: 1,
          )
        : BorderSide.none;
    final backgroundColor = Colors.blue.withOpacity(1.0 - _animation.value);
    final decoration = switch (_mode) {
      Mode.standard => BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
          border: Border.fromBorderSide(borderSide),
        ),
      Mode.cupertino => ShapeDecoration(
          shape: CupertinoRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: borderSide,
          ),
          color: backgroundColor,
        ),
    };
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          children: [
            SegmentedButton<Mode>(
              segments: const [
                ButtonSegment(
                  label: Text('Cupertino'),
                  value: Mode.cupertino,
                ),
                ButtonSegment(
                  label: Text('Standard'),
                  value: Mode.standard,
                ),
              ],
              onSelectionChanged: (selection) {
                setState(() {
                  _mode = selection.first;
                });
              },
              selected: {_mode},
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  label: Text('ShowBorder'),
                  value: true,
                ),
                ButtonSegment(
                  label: Text('HideBorder'),
                  value: false,
                ),
              ],
              onSelectionChanged: (selection) {
                setState(() {
                  _showBorder = selection.first;
                });
              },
              selected: {_showBorder},
            ),
            OutlinedButton(
              onPressed: () {
                _animation.repeat(reverse: true);
              },
              child: const Text('Animate'),
            ),
          ],
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              for (int i = 0; i < count; ++i)
                Positioned(
                  left: i * _animation.value,
                  top: i * _animation.value,
                  width: 100,
                  height: 100,
                  child: Container(
                    decoration: decoration,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
