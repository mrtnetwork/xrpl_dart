import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:blockchain_utils/utils/numbers/utils/bigint_utils.dart';
import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/base/base.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

class OracleConst {
  static const int maxOracleDataSeries = 10;
  static const int maxOracleSymbolClass = 16;
  static const int maxOracleProvider = 256;
  static const int maxOracleUri = 256;
  static const int epochOffset = 946684800;
}

/// Creates a new Oracle ledger entry or updates the fields of an existing one,
/// using the Oracle ID.
/// The oracle provider must complete these steps before submitting this transaction:
/// Create or own the XRPL account in the Owner field and have enough XRP to meet the
/// reserve and transaction fee requirements.
/// Publish the XRPL account public key, so it can be used for verification by dApps.
/// Publish a registry of available price oracles with their unique OracleDocumentID .
class OracleSet extends SubmittableTransaction {
  /// A unique identifier of the price oracle for the Account.
  final int oracleDocumentId;

  /// This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
  /// convert a UTF-8 string to hex.

  /// An arbitrary value that identifies an oracle provider, such as Chainlink, Band, or
  /// DIA. This field is a string, up to 256 ASCII hex encoded characters (0x20-0x7E).
  /// This field is required when creating a new Oracle ledger entry, but is optional for
  /// updates.
  final String? provider;

  /// This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
  /// convert a UTF-8 string to hex.
  /// An optional Universal Resource Identifier to reference price data off-chain. This
  /// field is limited to 256 bytes.
  final String? uri;

  ///  This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
  /// convert a UTF-8 string to hex.
  /// Describes the type of asset, such as "currency", "commodity", or "index". This
  /// field is a string, up to 16 ASCII hex encoded characters (0x20-0x7E). This field is
  /// required when creating a new Oracle ledger entry, but is optional for updates.
  final String? assetClass;

  /// LastUpdateTime is the specific point in time when the data was last updated.
  /// The LastUpdateTime is represented as Unix Time - the number of seconds since
  /// January 1, 1970 (00:00 UTC).
  final int lastUpdateTime;

  /// An array of up to 10 PriceData objects, each representing the price information
  /// for a token pair. More than five PriceData objects require two owner reserves.
  final List<PriceData> priceDataSeries;

  OracleSet(
      {required this.oracleDocumentId,
      this.provider,
      this.uri,
      this.assetClass,
      required this.lastUpdateTime,
      required List<PriceData> priceDataSeries,
      required super.account,
      super.accountTxId,
      super.fee,
      super.flags,
      super.lastLedgerSequence,
      super.memos,
      super.multisigSigners,
      super.networkId,
      super.sequence,
      super.signer,
      super.sourceTag,
      super.ticketSequance})
      : priceDataSeries = priceDataSeries.immutable,
        super(transactionType: SubmittableTransactionType.oracleSet);

  OracleSet.fromJson(super.json)
      : oracleDocumentId = IntUtils.parse(json["oracle_document_id"]),
        provider = (json["provider"] as String?)?.toLowerCase(),
        uri = (json["uri"] as String?)?.toLowerCase(),
        assetClass = (json["asset_class"] as String?)?.toLowerCase(),
        lastUpdateTime = IntUtils.parse(json["last_update_time"]),
        priceDataSeries = (json["price_data_series"] as List)
            .map((e) => PriceData.fromJson(e))
            .toImutableList,
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "oracle_document_id": oracleDocumentId,
      "provider": provider,
      "uri": uri,
      "asset_class": assetClass,
      "last_update_time": lastUpdateTime,
      "price_data_series": priceDataSeries.map((e) => e.toJson()).toList(),
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    // Validate priceDataSeries
    if (priceDataSeries.isEmpty) {
      return "The price data series must contain at least one entry.";
    }
    if (priceDataSeries.length > OracleConst.maxOracleDataSeries) {
      return "The price data series cannot exceed ${OracleConst.maxOracleDataSeries} entries.";
    }
    for (final priceData in priceDataSeries) {
      final hasAssetPrice = priceData.assetPrice != null;
      final hasScale = priceData.scale != null;
      if (hasAssetPrice != hasScale) {
        return "Each price data entry must have both 'assetPrice' and 'scale' set, or neither.";
      }
    }

    // Validate assetClass
    final assetClass = this.assetClass;
    if (assetClass != null) {
      if (assetClass.isEmpty) {
        return "Asset class cannot be empty.";
      }
      if (assetClass.length > OracleConst.maxOracleSymbolClass) {
        return "Asset class cannot exceed ${OracleConst.maxOracleSymbolClass} characters.";
      }
    }
    final provider = this.provider;
    // Validate provider
    if (provider != null) {
      if (provider.isEmpty) {
        return "Provider cannot be empty.";
      }
      if (provider.length > OracleConst.maxOracleProvider) {
        return "Provider cannot exceed ${OracleConst.maxOracleProvider} characters.";
      }
    }
    final uri = this.uri;
    // Validate uri
    if (uri != null) {
      if (uri.isEmpty) {
        return "URI cannot be empty.";
      }
      if (uri.length > OracleConst.maxOracleUri) {
        return "URI cannot exceed ${OracleConst.maxOracleUri} characters.";
      }
    }

    // Validate lastUpdateTime
    if (lastUpdateTime < OracleConst.epochOffset) {
      return "Last update time must be greater than or equal to the Ripple epoch offset (${OracleConst.epochOffset} seconds).";
    }

    return super.validate;
  }
}

/// Represents one PriceData element. It is used in OracleSet transaction
class PriceData extends XRPLBase {
  /// The primary asset in a trading pair. Any valid identifier, such as a stock
  /// symbol, bond CUSIP, or currency code is allowed. For example, in the BTC/USD pair,
  /// BTC is the base asset; in 912810RR9/BTC, 912810RR9 is the base asset.
  final String baseAsset;

  /// The quote asset in a trading pair. The quote asset denotes the price of one unit
  /// of the base asset. For example, in the BTC/USD pair, BTC is the base asset; in
  /// 912810RR9/BTC, 912810RR9 is the base asset.
  final String quoteAsset;

  /// The asset price after applying the Scale precision level. It's not included if
  /// the last update transaction didn't include the BaseAsset/QuoteAsset pair.
  final BigInt? assetPrice;

  /// The scaling factor to apply to an asset price. For example, if Scale is 6 and
  /// original price is 0.155, then the scaled price is 155000. Valid scale ranges are
  /// 0-10. It's not included if the last update transaction didn't include the
  /// BaseAsset/QuoteAsset pair.
  final int? scale;
  const PriceData(
      {required this.baseAsset,
      required this.quoteAsset,
      this.assetPrice,
      this.scale});
  PriceData.fromJson(Map<String, dynamic> json)
      : baseAsset = json["price_data"]["base_asset"],
        quoteAsset = json["price_data"]["quote_asset"],
        assetPrice = BigintUtils.tryParse(json["price_data"]["asset_price"]),
        scale = IntUtils.tryParse(json["price_data"]["scale"]);

  @override
  Map<String, dynamic> toJson() {
    return {
      "price_data": {
        "base_asset": baseAsset,
        "quote_asset": quoteAsset,
        "asset_price": assetPrice.toString(),
        "scale": scale
      }..removeWhere((_, v) => v == null)
    };
  }
}
