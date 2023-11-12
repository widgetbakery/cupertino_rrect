// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

typedef DriverTestCallBack = Future<void> Function(FlutterDriver driver);

Future<void> runDriverTest(
  DriverTestCallBack body,
) async {
  final FlutterDriver driver = await FlutterDriver.connect();

  // The slight initial delay avoids starting the timing during a
  // period of increased load on the device. Without this delay, the
  // benchmark has greater noise.
  // See: https://github.com/flutter/flutter/issues/19434
  await Future<void>.delayed(const Duration(milliseconds: 250));

  await driver.forceGC();

  await body(driver);

  driver.close();
}

void macroPerfTest(
  String testName, {
  Duration? delay,
  Duration duration = const Duration(seconds: 3),
  Future<void> Function(FlutterDriver driver)? driverOps,
  Future<void> Function(FlutterDriver driver)? setupOps,
}) {
  test(testName, () async {
    late Timeline timeline;
    await runDriverTest((FlutterDriver driver) async {
      if (setupOps != null) {
        await setupOps(driver);
      }

      if (delay != null) {
        await Future<void>.delayed(delay);
      }

      timeline = await driver.traceAction(() async {
        final Future<void> durationFuture = Future<void>.delayed(duration);
        if (driverOps != null) {
          await driverOps(driver);
        }
        await durationFuture;
      });
    });

    expect(timeline, isNotNull);

    final TimelineSummary summary = TimelineSummary.summarize(timeline);
    await summary.writeTimelineToFile(testName, pretty: true);
  }, timeout: Timeout.none);
}
