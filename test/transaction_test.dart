import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

final String memoData = BytesUtils.toHexString(
    'https://github.com/mrtnetwork/xrpl_dart'.codeUnits,
    lowerCase: false);
final String memoType =
    BytesUtils.toHexString('Text'.codeUnits, lowerCase: false);
final String mempFormat =
    BytesUtils.toHexString('text/plain'.codeUnits, lowerCase: false);
final exampleMemo =
    XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
void main() {
  group('Transaction', () {
    _test();
  });
}

void _test() {
  test('Payment', () {
    const blob =
        '535458001200002200000000240010ABFB201B0010AC53614000000000B71B0068400000000000000A732103A21EB8F8A58DE60D923621F63B6E821A1B0383401CBE37AE089571F3A4DDE5D181143609670A615BEDD7A20A0F76E5055FD2ED5DC984831457DAE62CD8431521DB6E01B2E26BADCB1E425FDDF9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F1';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(transaction.toBlob(), blob);
    expect(transaction.transactionType, XRPLTransactionType.payment);
    expect(transaction.memos[0].memoData, memoData);
    expect((transaction as Payment).amount.xrp, BigInt.from(12000000));
  });
  test('Payment_2', () {
    const blob =
        '535458001200002200000000240010ABFD2E00000019201B0010AFAA614000000000B71B0068400000000000000A732103A21EB8F8A58DE60D923621F63B6E821A1B0383401CBE37AE089571F3A4DDE5D181143609670A615BEDD7A20A0F76E5055FD2ED5DC9848314115697DFBB6E9D9C713A241D87FFB54C8728B937F9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F1';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(transaction.toBlob(), blob);
    expect(transaction.transactionType, XRPLTransactionType.payment);
    expect(transaction.memos[0].memoData, memoData);
    expect((transaction as Payment).amount.xrp, BigInt.from(12000000));
    expect((transaction).destinationTag, 25);
    final fromXrpl = XRPTransaction.fromBlob(transaction.toBlob());
    expect(transaction.toXrpl(), fromXrpl.toXrpl());
  });
  test('MintNFT', () {
    const blob =
        '535458001200192200000000240010ABFE201B0010B010202A0000000168400000000000000A732103A21EB8F8A58DE60D923621F63B6E821A1B0383401CBE37AE089571F3A4DDE5D1752768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F6461727481143609670A615BEDD7A20A0F76E5055FD2ED5DC984F9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F1';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(transaction.toBlob(), blob);
    expect(transaction.account, 'rnv5kChGCSrzKPJi6BidxiU3e3N9fxpfxq');
    expect(transaction.transactionType, XRPLTransactionType.nftokenMint);
    expect(transaction.signer?.signingPubKey,
        '03A21EB8F8A58DE60D923621F63B6E821A1B0383401CBE37AE089571F3A4DDE5D1');
    expect((transaction as NFTokenMint).nftokenTaxon, 1);
  });
  test('SignerListSet', () {
    const blob =
        '5354580012000C2200000000240010B04F201B0010B08320230000000268400000000000000A73210372A211BC750CBC51D1D29FB3D1615FD508D714F44BDDCC475029037346DFE12D8114F5CADBD9540B4DD2CBFD9FD1BDDFE4A302B2E1CEF4EB130001811462F2390039B80AFC196183290C3775974B9055CEE1EB1300028114238A512BFDB5FE589291A2009C21C22537D4FD4CE1F1F9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F1';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(transaction.toBlob(), blob);
    expect(transaction.account, 'rPQdZ1gtxLCZidafWTRDerhUeZAsZAvM29');
    expect(transaction.transactionType, XRPLTransactionType.signerListSet);
    expect(transaction.signer?.signingPubKey,
        '0372A211BC750CBC51D1D29FB3D1615FD508D714F44BDDCC475029037346DFE12D');
    final signerListSet = (transaction as SignerListSet);
    final signers = signerListSet.signerEntries!;

    expect(signers[0].account, 'rwpBPjsKpBDXKu1P7y19zTAPW4DkiqsavL');
    expect(signers[1].account, 'rhNvM9trpqmybHviu3PYRtTGg5bEGWruJg');
    expect(signerListSet.signerQuorum, 2);
    final fromXrpl = XRPTransaction.fromBlob(transaction.toBlob());
    expect(transaction.toXrpl(), fromXrpl.toXrpl());
  });
  test('AccountSet', () {
    const blob =
        '535458001200032200000000240010B050201B0010B0C820210000000468400000000000000A73210372A211BC750CBC51D1D29FB3D1615FD508D714F44BDDCC475029037346DFE12D8114F5CADBD9540B4DD2CBFD9FD1BDDFE4A302B2E1CEF9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F1';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(transaction.toBlob(), blob);
    expect(transaction.account, 'rPQdZ1gtxLCZidafWTRDerhUeZAsZAvM29');
    expect(transaction.transactionType, XRPLTransactionType.accountSet);
    expect(transaction.signer?.signingPubKey,
        '0372A211BC750CBC51D1D29FB3D1615FD508D714F44BDDCC475029037346DFE12D');
    final accountSet = (transaction as AccountSet);

    expect(accountSet.setFlag, AccountSetAsfFlag.asfDisableMaster);
    final fromXrpl = XRPTransaction.fromBlob(transaction.toBlob());
    expect(transaction.toXrpl(), fromXrpl.toXrpl());
  });
  test('Multisig', () {
    const blob =
        '534D54001200002200000000240010B053201B0010B239614000000000B71B0068400000000000002873008114F5CADBD9540B4DD2CBFD9FD1BDDFE4A302B2E1CE83143609670A615BEDD7A20A0F76E5055FD2ED5DC984F9EA7C04546578747D2768747470733A2F2F6769746875622E636F6D2F6D72746E6574776F726B2F7872706C5F646172747E0A746578742F706C61696EE1F162F2390039B80AFC196183290C3775974B9055CE';
    final transaction = XRPTransaction.fromBlob(blob);
    expect(
        transaction.toMultisigBlob('rwpBPjsKpBDXKu1P7y19zTAPW4DkiqsavL'), blob);
  });
}
