import 'package:flutter_driver/flutter_driver.dart';

import 'util.dart';

void main() {
  macroPerfTest(
    'standard_with_border_perf',
    setupOps: (driver) async {
      await driver.tap(find.text('Standard'));
      await driver.tap(find.text('ShowBorder'));
      await driver.tap(find.text('Animate'));
    },
    delay: const Duration(seconds: 1),
    duration: const Duration(seconds: 10),
  );
}
