import 'package:test/test.dart';
import 'package:xrpl_dart/src/rpc/methods/ledger_current.dart';
import 'utils.dart';

void ledgerCurrentParseTest() {
  test('ledger_current accepts ledger_current_index', () {
    final request = XRPRequestLedgerCurrent();
    expect(request.onResponse({'ledger_current_index': 123}), 123);
  });

  test('ledger_current accepts ledger_index fallback', () {
    final request = XRPRequestLedgerCurrent();
    expect(request.onResponse({'ledger_index': 456}), 456);
  });

  test('ledger_current accepts numeric strings', () {
    final request = XRPRequestLedgerCurrent();
    expect(request.onResponse({'ledger_current_index': '789'}), 789);
    expect(request.onResponse({'ledger_index': '101112'}), 101112);
  });

  test('ledger_current throws when both keys are missing', () {
    final request = XRPRequestLedgerCurrent();
    expect(() => request.onResponse({}), throwsA(anything));
    expect(
      () => request.onResponse({'ledger_current_index': 'not-a-number'}),
      throwsA(anything),
    );
  });
}

void main() {
  XrplTestApi.runTest(ledgerCurrentParseTest, 'Ledger Current Parse');
}
