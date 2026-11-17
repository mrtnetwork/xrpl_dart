import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
import 'utils.dart';


/// Offline tests for [XRPQuickClientApi] (fake provider, no network).
void quickClientTest() {

  const account = 'rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn';
  const issuer = 'rLaBCoaMQqXzHDmiGs2Qv2JA2bg3Yvzxyt';

  BaseAccountInfoResponse fakeAccountInfo({
    String balance = '2000000',
    int sequence = 7,
  }) {
    return BaseAccountInfoResponse.fromJson({
      'account_data': {
        'index': '00' * 32,
        'Account': account,
        'Balance': balance,
        'Flags': 0,
        'OwnerCount': 0,
        'PreviousTxnID': '00' * 32,
        'PreviousTxnLgrSeq': 1,
        'Sequence': sequence,
      },
    });
  }

  Payment samplePayment() {
    return Payment(
      account: account,
      destination: issuer,
      amount: XRPAmount(BigInt.from(100)),
    );
  }

  TxResult fakeTx({
    required String result,
    bool validated = true,
  }) {
    return TxResult(
      hash: 'AB' * 32,
      validated: validated,
      meta: PaymentMetadata(
        affectedNodes: const [],
        transactionIndex: 0,
        transactionResult: result,
      ),
      txJson: samplePayment(),
    );
  }

  XRPQuickClientApi quickWith(Map<Type, dynamic Function()> handlers) {
    return _Quick(_FakeProvider(handlers));
  }
  test('getAccountInfo maps actNotFound to null', () async {
    final quick = quickWith({
      XRPRequestAccountInfo: () => fakeAccountInfo(),
    });
    expect((await quick.getAccountInfo(account))?.accountData.sequence, 7);

    final missing = quickWith({
      XRPRequestAccountInfo: () => throw const RPCError(
        message: 'Account not found.',
        errorCode: 19,
      ),
    });
    expect(await missing.getAccountInfo(account), isNull);

    final missingByMessage = quickWith({
      XRPRequestAccountInfo: () => throw const RPCError(
        message: 'actNotFound: Account not found.',
      ),
    });
    expect(await missingByMessage.getAccountInfo(account), isNull);

    final failing = quickWith({
      XRPRequestAccountInfo: () => throw const RPCError(message: 'boom'),
    });
    await expectLater(failing.getAccountInfo(account), throwsA(isA<RPCError>()));
  });

  test('getAccountBalance parses drops, zero when missing', () async {
    final quick = quickWith({
      XRPRequestAccountInfo: () => fakeAccountInfo(balance: '2000000'),
    });
    expect(await quick.getAccountBalance(account), BigInt.from(2000000));

    final missing = quickWith({
      XRPRequestAccountInfo: () => throw const RPCError(
        message: 'actNotFound',
      ),
    });
    expect(await missing.getAccountBalance(account), BigInt.zero);
  });

  test('getAccountSequence reads the sequence', () async {
    final quick = quickWith({
      XRPRequestAccountInfo: () => fakeAccountInfo(sequence: 9),
    });
    expect(await quick.getAccountSequence(account), 9);
  });

  test('gatewayBalances passes through', () async {
    final quick = quickWith({
      XRPRequestGatewayBalances: () => GatewayBalancesResult.fromJson({
        'account': account,
        'obligations': {'USD': '100'},
        'assets': {
          issuer: [
            {'currency': 'USD', 'value': '50'},
          ],
        },
      }),
    });
    final r = await quick.gatewayBalances(account: account);
    expect(r.obligations, {'USD': '100'});
    expect(r.assets?[issuer]?.single.currency, 'USD');
  });

  test('transactionStatus maps block/failed/pending', () async {
    final block = quickWith({
      XRPRequestTx: () => fakeTx(result: 'tesSUCCESS'),
    });
    expect(await block.transactionStatus('AB' * 32), XRPQuickTxStatus.block);

    final failed = quickWith({
      XRPRequestTx: () => fakeTx(result: 'tecPATH_DRY'),
    });
    expect(await failed.transactionStatus('AB' * 32), XRPQuickTxStatus.failed);

    final pending = quickWith({
      XRPRequestTx: () => fakeTx(result: 'tesSUCCESS', validated: false),
    });
    expect(
      await pending.transactionStatus('AB' * 32),
      XRPQuickTxStatus.pending,
    );

    final missing = quickWith({
      XRPRequestTx: () => throw const RPCError(message: 'txnNotFound'),
    });
    expect(
      await missing.transactionStatus('AB' * 32),
      XRPQuickTxStatus.pending,
    );
  });

  test('submitTransaction passes the blob through', () async {
    final quick = quickWith({
      XRPRequestSubmit: () => SubmitResult.fromJson({
        'engine_result': 'tesSUCCESS',
        'engine_result_code': 0,
        'engine_result_message': 'The transaction was applied.',
        'tx_blob': '00',
        'tx_json': {
          'Account': account,
          'TransactionType': 'Payment',
          'Destination': issuer,
          'Amount': '100',
          'hash': 'AB' * 32,
        },
        'accepted': true,
        'applied': true,
        'broadcast': true,
        'kept': true,
        'queued': false,
      }),
    });
    final r = await quick.submitTransaction(samplePayment());
    expect(r.isSuccess, isTrue);
  });

  test('pollTransaction returns once validated', () async {
    var calls = 0;
    final quick = quickWith({
      XRPRequestTx: () {
        calls++;
        return fakeTx(result: 'tesSUCCESS', validated: calls >= 2);
      },
    });
    final r = await quick.pollTransaction(
      'AB' * 32,
      interval: const Duration(milliseconds: 1),
    );
    expect(r.validated, isTrue);
    expect(calls, 2);
  });
}

class _Quick with XRPQuickClientApi {
  _Quick(this._provider);
  final IProvider<IServiceProvider, XRPRequestDetails> _provider;
  @override
  IProvider<IServiceProvider, XRPRequestDetails> get provider => _provider;
}

class _FakeProvider implements IProvider<IServiceProvider, XRPRequestDetails> {
  final Map<Type, dynamic Function()> handlers;
  _FakeProvider(this.handlers);

  @override
  IServiceProvider get service => throw UnimplementedError();

  @override
  Future<RESULT> request<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, XRPRequestDetails> request, {
    Duration? timeout,
  }) async {
    final handler = handlers[request.runtimeType];
    if (handler == null) {
      throw StateError('Unexpected request ${request.runtimeType}');
    }
    return handler() as RESULT;
  }

  @override
  Future<SERVICERESPONSE> requestDynamic<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, XRPRequestDetails> request, {
    Duration? timeout,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  XrplTestApi.runTest(quickClientTest, 'Quick Client');
}
