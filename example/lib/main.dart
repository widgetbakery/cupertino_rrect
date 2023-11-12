import 'package:cupertino_rrect/cupertino_rrect.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double radius = 50;
  bool showStandard = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Radius: ${radius.roundToDouble()}'),
                  Slider(
                    value: radius,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: showStandard,
                        onChanged: (v) {
                          setState(() {
                            showStandard = v!;
                          });
                        },
                      ),
                      const Text('Show regular RRect'),
                    ],
                  ),
                ],
              ),
              Stack(
                fit: StackFit.passthrough,
                children: [
                  if (showStandard)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: Colors.red,
                      ),
                      width: 300,
                      height: 300,
                    ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: CupertinoRectangleBorder(
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      color: Colors.blue,
                    ),
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
