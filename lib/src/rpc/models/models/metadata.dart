import 'package:xrpl_dart/src/rpc/models/models/node.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

abstract class TransactionMetadataBase {
  final List<XRPNode> affectedNodes;
  final BaseAmount? deliveredAmount;
  final dynamic deliveredAmountAlt;
  final int transactionIndex;
  final String transactionResult;
  final String? parentBatchID;

  const TransactionMetadataBase(
      {required this.affectedNodes,
      required this.deliveredAmount,
      this.deliveredAmountAlt,
      required this.transactionIndex,
      required this.transactionResult,
      this.parentBatchID});
  factory TransactionMetadataBase.fromJson(
      Map<String, dynamic> json, XRPLTransactionType? type) {
    switch (type) {
      case SubmittableTransactionType.payment:
        return PaymentMetadata.fromJson(json);
      case SubmittableTransactionType.nftokenMint:
        return NFTokenMintMetadata.fromJson(json);
      case SubmittableTransactionType.nftokenCreateOffer:
        return NFTokenCreateOfferMetadata.fromJson(json);
      case SubmittableTransactionType.nftokenAcceptOffer:
        return NFTokenAcceptOfferMetadata.fromJson(json);
      case SubmittableTransactionType.nftokenCancelOffer:
        return NFTokenCancelOfferMetadata.fromJson(json);
      case SubmittableTransactionType.mpTokenIssuanceCreate:
        return MPTokenIssuanceCreateMetadata.fromJson(json);
      default:
        return TransactionMetadata.fromJson(json);
    }
  }

  TransactionMetadataBase._fromJson(Map<String, dynamic> json)
      : affectedNodes = (json['AffectedNodes'] as List)
            .map((e) => XRPNode.fromJson(e))
            .toList(),
        deliveredAmount = json['DeliveredAmount'] != null
            ? BaseAmount.fromJson(json['DeliveredAmount'])
            : null,
        deliveredAmountAlt = json['delivered_amount'],
        transactionIndex = json['TransactionIndex'],
        transactionResult = json['TransactionResult'],
        parentBatchID = json['ParentBatchID'];

  Map<String, dynamic> toJson() {
    return {
      'AffectedNodes': affectedNodes.map((e) => e.toJson()).toList(),
      'DeliveredAmount': deliveredAmount?.toJson(),
      'delivered_amount': deliveredAmountAlt,
      'TransactionIndex': transactionIndex,
      'TransactionResult': transactionResult,
      'ParentBatchID': parentBatchID,
    };
  }
}

class PaymentMetadata extends TransactionMetadataBase {
  PaymentMetadata({
    required super.affectedNodes,
    super.deliveredAmount,
    super.deliveredAmountAlt,
    required super.transactionIndex,
    required super.transactionResult,
    super.parentBatchID,
  });

  PaymentMetadata.fromJson(super.json) : super._fromJson();
}

class NFTokenMintMetadata extends TransactionMetadataBase {
  final String? nftokenId;
  final String? offerId;

  const NFTokenMintMetadata({
    required super.affectedNodes,
    super.deliveredAmountAlt,
    required super.transactionIndex,
    required super.transactionResult,
    super.parentBatchID,
    super.deliveredAmount,
    this.nftokenId,
    this.offerId,
  });

  NFTokenMintMetadata.fromJson(super.json)
      : nftokenId = json['nftoken_id'],
        offerId = json['offer_id'],
        super._fromJson();
}

class NFTokenCreateOfferMetadata extends TransactionMetadataBase {
  final String? offerId;

  const NFTokenCreateOfferMetadata({
    required super.affectedNodes,
    super.deliveredAmountAlt,
    required super.transactionIndex,
    required super.transactionResult,
    super.parentBatchID,
    super.deliveredAmount,
    this.offerId,
  });

  NFTokenCreateOfferMetadata.fromJson(super.json)
      : offerId = json['offer_id'],
        super._fromJson();
}

class NFTokenAcceptOfferMetadata extends TransactionMetadataBase {
  final String? nftokenId;

  const NFTokenAcceptOfferMetadata({
    required super.affectedNodes,
    super.deliveredAmountAlt,
    required super.transactionIndex,
    required super.transactionResult,
    super.parentBatchID,
    super.deliveredAmount,
    this.nftokenId,
  });

  NFTokenAcceptOfferMetadata.fromJson(super.json)
      : nftokenId = json['nftoken_id'],
        super._fromJson();
}

class NFTokenCancelOfferMetadata extends TransactionMetadataBase {
  final List<String>? nftokenIds;

  const NFTokenCancelOfferMetadata(
      {required super.affectedNodes,
      super.deliveredAmountAlt,
      required super.transactionIndex,
      required super.transactionResult,
      super.parentBatchID,
      super.deliveredAmount,
      this.nftokenIds});

  NFTokenCancelOfferMetadata.fromJson(super.json)
      : nftokenIds = (json['nftoken_ids'] as List?)?.cast(),
        super._fromJson();
}

class MPTokenIssuanceCreateMetadata extends TransactionMetadataBase {
  final String? mptIssuanceId;

  const MPTokenIssuanceCreateMetadata(
      {required super.affectedNodes,
      super.deliveredAmountAlt,
      required super.transactionIndex,
      required super.transactionResult,
      super.parentBatchID,
      super.deliveredAmount,
      this.mptIssuanceId});

  MPTokenIssuanceCreateMetadata.fromJson(super.json)
      : mptIssuanceId = json["mpt_issuance_id"],
        super._fromJson();
}

class TransactionMetadata extends TransactionMetadataBase {
  const TransactionMetadata(
      {required super.affectedNodes,
      super.deliveredAmountAlt,
      required super.transactionIndex,
      required super.transactionResult,
      super.parentBatchID,
      super.deliveredAmount});

  TransactionMetadata.fromJson(super.json) : super._fromJson();
}
// abstract class
