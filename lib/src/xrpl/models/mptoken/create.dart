import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'package:blockchain_utils/utils/string/string.dart';
import 'package:xrpl_dart/src/xrpl/models/base/base.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

class MPTokenIssuanceCreateConst {
  static const int maxTransferFee = 50000;
}

/// Transactions of the MPTokenIssuanceCreate type support additional values in the
/// Flags field.
/// This enum represents those options.
class MPTokenIssuanceCreateFlag implements FlagsInterface {
  static const MPTokenIssuanceCreateFlag tfMptCanLock =
      MPTokenIssuanceCreateFlag(0x00000002);

  static const MPTokenIssuanceCreateFlag tfMptRequireAuth =
      MPTokenIssuanceCreateFlag(0x00000004);

  static const MPTokenIssuanceCreateFlag tfMptCanEscrow =
      MPTokenIssuanceCreateFlag(0x00000008);

  static const MPTokenIssuanceCreateFlag tfMptCanTrade =
      MPTokenIssuanceCreateFlag(0x00000010);

  static const MPTokenIssuanceCreateFlag tfMptCanTransfer =
      MPTokenIssuanceCreateFlag(0x00000020);

  static const MPTokenIssuanceCreateFlag tfMptCanClawback =
      MPTokenIssuanceCreateFlag(0x00000040);

  // The integer value associated with each flag.
  final int value;

  const MPTokenIssuanceCreateFlag(this.value);

  @override
  int get id => value;
}

/// The MPTokenIssuanceCreate transaction creates a MPTokenIssuance object
/// and adds it to the relevant directory node of the creator account.
/// This transaction is the only opportunity an issuer has to specify any token fields
/// that are defined as immutable (e.g., MPT Flags). If the transaction is successful,
/// the newly created token will be owned by the account (the creator account) which
/// executed the transaction.
class MPTokenIssuanceCreate extends SubmittableTransaction {
  /// An asset scale is the difference, in orders of magnitude, between a standard unit
  /// and a corresponding fractional unit. More formally, the asset scale is a
  /// non-negative integer (0, 1, 2, …) such that one standard unit equals 10^(-scale) of
  /// a corresponding fractional unit. If the fractional unit equals the standard unit,
  /// then the asset scale is 0.
  /// Note that this value is optional, and will default to 0 if not supplied.
  final int? assetScale;

  /// Specifies the maximum asset amount of this token that should ever be issued.
  /// It is a non-negative integer string that can store a range of up to 63 bits. If
  /// not set, the max amount will default to the largest unsigned 63-bit integer
  /// (0x7FFFFFFFFFFFFFFF)
  final String? maximumAmount;

  /// Specifies the fee to charged by the issuer for secondary sales of the Token,
  /// if such sales are allowed. Valid values for this field are between 0 and 50,000
  /// inclusive, allowing transfer rates of between 0.000% and 50.000% in increments of
  /// 0.001. The field must NOT be present if the `tfMPTCanTransfer` flag is not set.
  final int? transferFee;

  /// Arbitrary metadata about this issuance, in hex format.
  final String? mptokenMetadata;
  MPTokenIssuanceCreate({
    this.assetScale,
    this.maximumAmount,
    this.transferFee,
    this.mptokenMetadata,
    required super.account,
  }) : super(transactionType: SubmittableTransactionType.mpTokenIssuanceCreate);

  MPTokenIssuanceCreate.fromJson(super.json)
      : assetScale = IntUtils.tryParse(json["asset_scale"]),
        maximumAmount = json["maximum_amount"],
        transferFee = IntUtils.tryParse(json["transfer_fee"]),
        mptokenMetadata = json["mptoken_metadata"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "asset_scale": assetScale,
      "maximum_amount": maximumAmount,
      "transfer_fee": transferFee,
      "mptoken_metadata": mptokenMetadata,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    final fee = transferFee;
    if (fee != null) {
      if (!flags.contains(MPTokenIssuanceCreateFlag.tfMptCanTransfer.value)) {
        return "Transfer fee cannot be provided unless the 'tfMPTCanTransfer' flag is enabled.";
      }
      if (fee.isNegative || fee > MPTokenIssuanceCreateConst.maxTransferFee) {
        return "Transfer fee must be between 0 and ${MPTokenIssuanceCreateConst.maxTransferFee}.";
      }
    }

    final metadata = mptokenMetadata;
    if (metadata != null) {
      if (metadata.isEmpty) {
        return "Metadata must not be empty.";
      }
      if (!StringUtils.isHexBytes(metadata)) {
        return "Metadata must be a valid hexadecimal string.";
      }
    }
    return super.validate;
  }
}
