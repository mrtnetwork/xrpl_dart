import 'package:xrp_dart/src/rpc/xrpl_rpc.dart';

import 'transactions/amm_test.dart';
import 'transactions/block_hole_account_test.dart';
import 'transactions/check_test.dart';
import 'transactions/create_ticket_test.dart';
import 'transactions/escrow_test.dart';
import 'transactions/issue_token_test.dart';
import 'transactions/nft_token_test.dart';
import 'transactions/path_set_test.dart';
import 'transactions/payment_channel_test.dart';
import 'transactions/reqular_key_test.dart';
import 'transactions/simple_transaction_test.dart';
import 'transactions/xrpl_multisig_test.dart';

final rpc = XRPLRpc.testNet();
void main() async {
  reqularKeyTest();
  simpleTransactionTest();
  ammTest();
  blockHoleTest();
  checkTest();
  createTicketTest();
  escrowTest();
  issueTokenTest();
  nftTokenTest();
  pathSetTest();
  paymentChannelTest();
  multiSigTest();
}
