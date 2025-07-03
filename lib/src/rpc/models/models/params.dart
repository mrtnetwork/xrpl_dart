import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class DepositPreauthParams {
  const DepositPreauthParams({required this.owner, required this.authorized});
  final String owner;
  final String authorized;

  Map<String, dynamic> toJson() {
    return {'owner': owner, 'authorized': authorized};
  }
}

class DirectoryParams {
  const DirectoryParams(
      {required this.owner, required this.dirRoot, this.subIndex});
  final String owner;
  final String dirRoot;
  final int? subIndex;
  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'dir_root': dirRoot,
      'sub_index': subIndex,
    };
  }
}

class EscrowParams {
  const EscrowParams({required this.owner, required this.seq});
  final String owner;
  final int seq;
  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'seq': seq,
    };
  }
}

class OfferParams {
  const OfferParams({required this.account, required this.seq});
  final String account;
  final int seq;
  Map<String, dynamic> toJson() {
    return {'account': account, 'seq': seq};
  }
}

class RippleStateParams {
  const RippleStateParams({required this.currency, required this.accounts});
  final String currency;
  final List<String> accounts;

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'accounts': accounts,
    };
  }
}

class TicketParams {
  const TicketParams({required this.owner, required this.ticketSequence});
  final String owner;
  final int ticketSequence;

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'ticket_sequence': ticketSequence,
    };
  }
}

class MptokenParams {
  final String mptIssuanceId;
  final String account;

  const MptokenParams({required this.mptIssuanceId, required this.account});

  Map<String, dynamic> toJson() {
    return {
      'mpt_issuance_id': mptIssuanceId,
      'account': account,
    };
  }
}

class XChainOwnedClaimIDParams {
  final String lockingChainDoor;
  final BaseCurrency lockingChainIssue;
  final String issuingChainDoor;
  final BaseCurrency issuingChainIssue;
  final int xChainOwnedClaimId;
  XChainOwnedClaimIDParams(
      {required this.issuingChainDoor,
      required this.issuingChainIssue,
      required this.lockingChainDoor,
      required this.lockingChainIssue,
      required this.xChainOwnedClaimId});

  Map<String, dynamic> toJson() {
    return {
      'locking_chain_door': lockingChainDoor,
      'locking_chain_issue': lockingChainIssue.toJson(),
      'issuing_chain_door': issuingChainDoor,
      'issuing_chain_issue': issuingChainIssue.toJson(),
      "xchain_owned_claim_id": xChainOwnedClaimId
    };
  }
}

class XChainOwnedCreateAccountClaimIDParams {
  final String lockingChainDoor;
  final BaseCurrency lockingChainIssue;
  final String issuingChainDoor;
  final BaseCurrency issuingChainIssue;
  XChainOwnedCreateAccountClaimIDParams(
      {required this.issuingChainDoor,
      required this.issuingChainIssue,
      required this.lockingChainDoor,
      required this.lockingChainIssue,
      required this.xOwnedChainCreateAccountClaimId});
  final int xOwnedChainCreateAccountClaimId;

  Map<String, dynamic> toJson() {
    return {
      'locking_chain_door': lockingChainDoor,
      'locking_chain_issue': lockingChainIssue.toJson(),
      'issuing_chain_door': issuingChainDoor,
      'issuing_chain_issue': issuingChainIssue.toJson(),
      'xchain_owned_create_account_claim_id': xOwnedChainCreateAccountClaimId,
    };
  }
}

class AMMAssetParams {
  final String currency;
  final String? issuer;

  const AMMAssetParams({required this.currency, this.issuer});

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'issuer': issuer,
    };
  }
}

class AMMParams {
  final AMMAssetParams asset;
  final AMMAssetParams asset2;

  const AMMParams({required this.asset, required this.asset2});

  Map<String, dynamic> toJson() {
    return {
      'asset': asset.toJson(),
      'asset2': asset2.toJson(),
    };
  }
}

class CredentialParams {
  final String subject;
  final String issuer;
  final String credentialType;

  CredentialParams({
    required this.subject,
    required this.issuer,
    required this.credentialType,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'issuer': issuer,
      'credentialType': credentialType,
    };
  }
}

class XChainBridgeParams {
  const XChainBridgeParams(
      {required this.issuingChainDoor,
      required this.issuingChainIssue,
      required this.lockingChainDoor,
      required this.lockingChainIssue});

  final String lockingChainDoor;

  final BaseCurrency lockingChainIssue;

  final String issuingChainDoor;

  final BaseCurrency issuingChainIssue;

  Map<String, dynamic> toJson() {
    return {
      'LockingChainDoor': lockingChainDoor,
      'LockingChainIssue': lockingChainIssue.toJson(),
      'IssuingChainDoor': issuingChainDoor,
      'IssuingChainIssue': issuingChainIssue.toJson()
    };
  }
}

class DelegateParams {
  final String account;
  final String authorize;

  DelegateParams({
    required this.account,
    required this.authorize,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'authorize': authorize,
    };
  }
}
