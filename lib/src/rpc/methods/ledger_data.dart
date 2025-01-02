import 'package:xrpl_dart/src/rpc/rpc.dart';

class LedgerEntryType {
  /// Represents an account ledger entry type.
  static const LedgerEntryType account = LedgerEntryType._('account');

  /// Represents an amendments ledger entry type.
  static const LedgerEntryType amendments = LedgerEntryType._('amendments');

  /// Represents a check ledger entry type.
  static const LedgerEntryType check = LedgerEntryType._('check');

  /// Represents a deposit_preauth ledger entry type.
  static const LedgerEntryType depositPreauth =
      LedgerEntryType._('deposit_preauth');

  /// Represents a directory ledger entry type.
  static const LedgerEntryType directory = LedgerEntryType._('directory');

  /// Represents an escrow ledger entry type.
  static const LedgerEntryType escrow = LedgerEntryType._('escrow');

  /// Represents a fee ledger entry type.
  static const LedgerEntryType fee = LedgerEntryType._('fee');

  /// Represents a hashes ledger entry type.
  static const LedgerEntryType hashes = LedgerEntryType._('hashes');

  /// Represents an offer ledger entry type.
  static const LedgerEntryType offer = LedgerEntryType._('offer');

  /// Represents a payment_channel ledger entry type.
  static const LedgerEntryType paymentChannel =
      LedgerEntryType._('payment_channel');

  /// Represents a signer_list ledger entry type.
  static const LedgerEntryType signerList = LedgerEntryType._('signer_list');

  /// Represents a state ledger entry type.
  static const LedgerEntryType state = LedgerEntryType._('state');

  /// Represents a ticket ledger entry type.
  static const LedgerEntryType ticket = LedgerEntryType._('ticket');

  /// Represents an NFT (Non-Fungible Token) offer ledger entry type.
  static const LedgerEntryType nftOffer = LedgerEntryType._('nft_offer');

  /// The string value associated with each ledger entry type.
  final String value;

  /// Private constructor to initialize the string value for each ledger entry type.
  const LedgerEntryType._(this.value);
}

/// The ledger_data method retrieves contents of
/// the specified ledger. You can iterate through
/// several calls to retrieve the entire contents
/// of a single ledger version.
/// See [ledger data](https://xrpl.org/ledger_data.html)
class XRPRequestLedgerData
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestLedgerData({
    this.type,
    this.limit,
    this.marker,
    this.binary = false,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.ledgerData;

  final int? limit;
  final dynamic marker;
  final bool binary;
  final LedgerEntryType? type;

  @override
  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'marker': marker,
      'binary': binary,
      'type': type?.value
    };
  }
}
