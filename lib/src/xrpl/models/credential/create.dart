import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

class CredentialCreateConst {
  static const int maxUrlLength = 255;
  static const int maxCredentialTypeLenght = 128;
}

class CredentialUtils {
  static String? validateCredentialType(String credentialType) {
    if (credentialType.isEmpty) {
      return "Credential type must not be empty.";
    }
    if (credentialType.length > CredentialCreateConst.maxCredentialTypeLenght) {
      return "Credential type length must not exceed ${CredentialCreateConst.maxCredentialTypeLenght} characters.";
    }
    if (!StringUtils.isHexBytes(credentialType)) {
      return "Credential type must be a valid hexadecimal string.";
    }

    return null;
  }
}

class CredentialCreate extends SubmittableTransaction {
  /// The subject of the credential.
  final String subject;

  /// A hex-encoded value to identify the type of credential from the issuer.
  final String credentialType;

  /// The credential expiration.
  final int? expiration;

  /// Additional data about the credential (such as a link to the Verifiable
  /// Credential document).
  final String? uri;

  CredentialCreate(
      {required this.subject,
      required this.credentialType,
      this.expiration,
      this.uri,
      required super.account,
      super.accountTxId,
      super.fee,
      super.flags,
      super.lastLedgerSequence,
      super.multisigSigners,
      super.memos,
      super.sequence,
      super.signer,
      super.sourceTag,
      super.ticketSequance,
      super.networkId})
      : super(transactionType: SubmittableTransactionType.credentialCreate);

  CredentialCreate.fromJson(super.json)
      : subject = json['subject'],
        credentialType = json['credential_type'],
        expiration = IntUtils.tryParse(json["expiration"]),
        uri = json["uri"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "credential_type": credentialType,
      "subject": subject,
      "expiration": expiration,
      "uri": uri,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    final uri = this.uri;
    if (uri != null) {
      if (uri.isEmpty) {
        return "URI must not be empty.";
      }
      if (uri.length > CredentialCreateConst.maxUrlLength) {
        return "URI length must not exceed ${CredentialCreateConst.maxUrlLength} characters.";
      }
      if (!StringUtils.isHexBytes(uri)) {
        return "URI must be a valid hexadecimal string.";
      }
    }
    final typeError = CredentialUtils.validateCredentialType(credentialType);

    return typeError ?? super.validate;
  }
}
