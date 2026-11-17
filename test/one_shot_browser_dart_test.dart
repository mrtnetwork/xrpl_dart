// Full `xrpl_dart` suite in Chrome against the pure-Dart backend (dart2js).
//
//   CHROME_EXECUTABLE=<wrapper> dart test -p chrome test/one_shot_browser_dart_test.dart
@TestOn('browser')
@Tags(['wasm'])
library;

import 'package:test/test.dart';

import 'one_shot_suite.dart';
import 'utils.dart';

void main() async {
  XrplTestApi.configure(
    const BuTestConfig(
      backend: BuTestBackend.dart,
      vectorTake: 3,
      fuzzIterations: 200,
      generatorTotal: 2,
    ),
  );
  await runOneShotSuite();
}
