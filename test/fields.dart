final Map<String, dynamic> definationFields = {
  "FIELDS": {
    "Generic": [
      "Generic",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 0,
        "type": "Unknown"
      }
    ],
    "Invalid": [
      "Invalid",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": -1,
        "type": "Unknown"
      }
    ],
    "ObjectEndMarker": [
      "ObjectEndMarker",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "STObject"
      }
    ],
    "ArrayEndMarker": [
      "ArrayEndMarker",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "STArray"
      }
    ],
    "taker_gets_funded": [
      "taker_gets_funded",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 258,
        "type": "Amount"
      }
    ],
    "taker_pays_funded": [
      "taker_pays_funded",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 259,
        "type": "Amount"
      }
    ],
    "LedgerEntryType": [
      "LedgerEntryType",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "UInt16"
      }
    ],
    "TransactionType": [
      "TransactionType",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "UInt16"
      }
    ],
    "SignerWeight": [
      "SignerWeight",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "UInt16"
      }
    ],
    "TransferFee": [
      "TransferFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "UInt16"
      }
    ],
    "TradingFee": [
      "TradingFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "UInt16"
      }
    ],
    "DiscountedFee": [
      "DiscountedFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "UInt16"
      }
    ],
    "Version": [
      "Version",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "UInt16"
      }
    ],
    "HookStateChangeCount": [
      "HookStateChangeCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "UInt16"
      }
    ],
    "HookEmitCount": [
      "HookEmitCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "UInt16"
      }
    ],
    "HookExecutionIndex": [
      "HookExecutionIndex",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "UInt16"
      }
    ],
    "HookApiVersion": [
      "HookApiVersion",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "UInt16"
      }
    ],
    "LedgerFixType": [
      "LedgerFixType",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "UInt16"
      }
    ],
    "NetworkID": [
      "NetworkID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "UInt32"
      }
    ],
    "Flags": [
      "Flags",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "UInt32"
      }
    ],
    "SourceTag": [
      "SourceTag",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "UInt32"
      }
    ],
    "Sequence": [
      "Sequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "UInt32"
      }
    ],
    "PreviousTxnLgrSeq": [
      "PreviousTxnLgrSeq",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "UInt32"
      }
    ],
    "LedgerSequence": [
      "LedgerSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "UInt32"
      }
    ],
    "CloseTime": [
      "CloseTime",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "UInt32"
      }
    ],
    "ParentCloseTime": [
      "ParentCloseTime",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "UInt32"
      }
    ],
    "SigningTime": [
      "SigningTime",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "UInt32"
      }
    ],
    "Expiration": [
      "Expiration",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "UInt32"
      }
    ],
    "TransferRate": [
      "TransferRate",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "UInt32"
      }
    ],
    "WalletSize": [
      "WalletSize",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "UInt32"
      }
    ],
    "OwnerCount": [
      "OwnerCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "UInt32"
      }
    ],
    "DestinationTag": [
      "DestinationTag",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 14,
        "type": "UInt32"
      }
    ],
    "LastUpdateTime": [
      "LastUpdateTime",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 15,
        "type": "UInt32"
      }
    ],
    "HighQualityIn": [
      "HighQualityIn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "UInt32"
      }
    ],
    "HighQualityOut": [
      "HighQualityOut",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "UInt32"
      }
    ],
    "LowQualityIn": [
      "LowQualityIn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "UInt32"
      }
    ],
    "LowQualityOut": [
      "LowQualityOut",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "UInt32"
      }
    ],
    "QualityIn": [
      "QualityIn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "UInt32"
      }
    ],
    "QualityOut": [
      "QualityOut",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "UInt32"
      }
    ],
    "StampEscrow": [
      "StampEscrow",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "UInt32"
      }
    ],
    "BondAmount": [
      "BondAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 23,
        "type": "UInt32"
      }
    ],
    "LoadFee": [
      "LoadFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "UInt32"
      }
    ],
    "OfferSequence": [
      "OfferSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "UInt32"
      }
    ],
    "FirstLedgerSequence": [
      "FirstLedgerSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "UInt32"
      }
    ],
    "LastLedgerSequence": [
      "LastLedgerSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "UInt32"
      }
    ],
    "TransactionIndex": [
      "TransactionIndex",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "UInt32"
      }
    ],
    "OperationLimit": [
      "OperationLimit",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "UInt32"
      }
    ],
    "ReferenceFeeUnits": [
      "ReferenceFeeUnits",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 30,
        "type": "UInt32"
      }
    ],
    "ReserveBase": [
      "ReserveBase",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 31,
        "type": "UInt32"
      }
    ],
    "ReserveIncrement": [
      "ReserveIncrement",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 32,
        "type": "UInt32"
      }
    ],
    "SetFlag": [
      "SetFlag",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 33,
        "type": "UInt32"
      }
    ],
    "ClearFlag": [
      "ClearFlag",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 34,
        "type": "UInt32"
      }
    ],
    "SignerQuorum": [
      "SignerQuorum",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 35,
        "type": "UInt32"
      }
    ],
    "CancelAfter": [
      "CancelAfter",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 36,
        "type": "UInt32"
      }
    ],
    "FinishAfter": [
      "FinishAfter",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 37,
        "type": "UInt32"
      }
    ],
    "SignerListID": [
      "SignerListID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 38,
        "type": "UInt32"
      }
    ],
    "SettleDelay": [
      "SettleDelay",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 39,
        "type": "UInt32"
      }
    ],
    "TicketCount": [
      "TicketCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 40,
        "type": "UInt32"
      }
    ],
    "TicketSequence": [
      "TicketSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 41,
        "type": "UInt32"
      }
    ],
    "NFTokenTaxon": [
      "NFTokenTaxon",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 42,
        "type": "UInt32"
      }
    ],
    "MintedNFTokens": [
      "MintedNFTokens",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 43,
        "type": "UInt32"
      }
    ],
    "BurnedNFTokens": [
      "BurnedNFTokens",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 44,
        "type": "UInt32"
      }
    ],
    "HookStateCount": [
      "HookStateCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 45,
        "type": "UInt32"
      }
    ],
    "EmitGeneration": [
      "EmitGeneration",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 46,
        "type": "UInt32"
      }
    ],
    "VoteWeight": [
      "VoteWeight",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 48,
        "type": "UInt32"
      }
    ],
    "FirstNFTokenSequence": [
      "FirstNFTokenSequence",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 50,
        "type": "UInt32"
      }
    ],
    "OracleDocumentID": [
      "OracleDocumentID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 51,
        "type": "UInt32"
      }
    ],
    "PermissionValue": [
      "PermissionValue",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 52,
        "type": "UInt32"
      }
    ],
    "IndexNext": [
      "IndexNext",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "UInt64"
      }
    ],
    "IndexPrevious": [
      "IndexPrevious",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "UInt64"
      }
    ],
    "BookNode": [
      "BookNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "UInt64"
      }
    ],
    "OwnerNode": [
      "OwnerNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "UInt64"
      }
    ],
    "BaseFee": [
      "BaseFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "UInt64"
      }
    ],
    "ExchangeRate": [
      "ExchangeRate",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "UInt64"
      }
    ],
    "LowNode": [
      "LowNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "UInt64"
      }
    ],
    "HighNode": [
      "HighNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "UInt64"
      }
    ],
    "DestinationNode": [
      "DestinationNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "UInt64"
      }
    ],
    "Cookie": [
      "Cookie",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "UInt64"
      }
    ],
    "ServerVersion": [
      "ServerVersion",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "UInt64"
      }
    ],
    "NFTokenOfferNode": [
      "NFTokenOfferNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "UInt64"
      }
    ],
    "EmitBurden": [
      "EmitBurden",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "UInt64"
      }
    ],
    "HookOn": [
      "HookOn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "UInt64"
      }
    ],
    "HookInstructionCount": [
      "HookInstructionCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "UInt64"
      }
    ],
    "HookReturnCode": [
      "HookReturnCode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "UInt64"
      }
    ],
    "ReferenceCount": [
      "ReferenceCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "UInt64"
      }
    ],
    "XChainClaimID": [
      "XChainClaimID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "UInt64"
      }
    ],
    "XChainAccountCreateCount": [
      "XChainAccountCreateCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "UInt64"
      }
    ],
    "XChainAccountClaimCount": [
      "XChainAccountClaimCount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "UInt64"
      }
    ],
    "AssetPrice": [
      "AssetPrice",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 23,
        "type": "UInt64"
      }
    ],
    "MaximumAmount": [
      "MaximumAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "UInt64"
      }
    ],
    "OutstandingAmount": [
      "OutstandingAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "UInt64"
      }
    ],
    "MPTAmount": [
      "MPTAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "UInt64"
      }
    ],
    "IssuerNode": [
      "IssuerNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "UInt64"
      }
    ],
    "SubjectNode": [
      "SubjectNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "UInt64"
      }
    ],
    "LockedAmount": [
      "LockedAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "UInt64"
      }
    ],
    "EmailHash": [
      "EmailHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Hash128"
      }
    ],
    "LedgerHash": [
      "LedgerHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Hash256"
      }
    ],
    "ParentHash": [
      "ParentHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Hash256"
      }
    ],
    "TransactionHash": [
      "TransactionHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "Hash256"
      }
    ],
    "AccountHash": [
      "AccountHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "Hash256"
      }
    ],
    "PreviousTxnID": [
      "PreviousTxnID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "Hash256"
      }
    ],
    "LedgerIndex": [
      "LedgerIndex",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "Hash256"
      }
    ],
    "WalletLocator": [
      "WalletLocator",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "Hash256"
      }
    ],
    "RootIndex": [
      "RootIndex",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "Hash256"
      }
    ],
    "AccountTxnID": [
      "AccountTxnID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "Hash256"
      }
    ],
    "NFTokenID": [
      "NFTokenID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "Hash256"
      }
    ],
    "EmitParentTxnID": [
      "EmitParentTxnID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "Hash256"
      }
    ],
    "EmitNonce": [
      "EmitNonce",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "Hash256"
      }
    ],
    "EmitHookHash": [
      "EmitHookHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "Hash256"
      }
    ],
    "AMMID": [
      "AMMID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 14,
        "type": "Hash256"
      }
    ],
    "BookDirectory": [
      "BookDirectory",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "Hash256"
      }
    ],
    "InvoiceID": [
      "InvoiceID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "Hash256"
      }
    ],
    "Nickname": [
      "Nickname",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "Hash256"
      }
    ],
    "Amendment": [
      "Amendment",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "Hash256"
      }
    ],
    "Digest": [
      "Digest",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "Hash256"
      }
    ],
    "Channel": [
      "Channel",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "Hash256"
      }
    ],
    "ConsensusHash": [
      "ConsensusHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 23,
        "type": "Hash256"
      }
    ],
    "CheckID": [
      "CheckID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "Hash256"
      }
    ],
    "ValidatedHash": [
      "ValidatedHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "Hash256"
      }
    ],
    "PreviousPageMin": [
      "PreviousPageMin",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "Hash256"
      }
    ],
    "NextPageMin": [
      "NextPageMin",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "Hash256"
      }
    ],
    "NFTokenBuyOffer": [
      "NFTokenBuyOffer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "Hash256"
      }
    ],
    "NFTokenSellOffer": [
      "NFTokenSellOffer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "Hash256"
      }
    ],
    "HookStateKey": [
      "HookStateKey",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 30,
        "type": "Hash256"
      }
    ],
    "HookHash": [
      "HookHash",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 31,
        "type": "Hash256"
      }
    ],
    "HookNamespace": [
      "HookNamespace",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 32,
        "type": "Hash256"
      }
    ],
    "HookSetTxnID": [
      "HookSetTxnID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 33,
        "type": "Hash256"
      }
    ],
    "DomainID": [
      "DomainID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 34,
        "type": "Hash256"
      }
    ],
    "VaultID": [
      "VaultID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 35,
        "type": "Hash256"
      }
    ],
    "ParentBatchID": [
      "ParentBatchID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 36,
        "type": "Hash256"
      }
    ],
    "hash": [
      "hash",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 257,
        "type": "Hash256"
      }
    ],
    "index": [
      "index",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 258,
        "type": "Hash256"
      }
    ],
    "Amount": [
      "Amount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Amount"
      }
    ],
    "Balance": [
      "Balance",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Amount"
      }
    ],
    "LimitAmount": [
      "LimitAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "Amount"
      }
    ],
    "TakerPays": [
      "TakerPays",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "Amount"
      }
    ],
    "TakerGets": [
      "TakerGets",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "Amount"
      }
    ],
    "LowLimit": [
      "LowLimit",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "Amount"
      }
    ],
    "HighLimit": [
      "HighLimit",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "Amount"
      }
    ],
    "Fee": [
      "Fee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "Amount"
      }
    ],
    "SendMax": [
      "SendMax",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "Amount"
      }
    ],
    "DeliverMin": [
      "DeliverMin",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "Amount"
      }
    ],
    "Amount2": [
      "Amount2",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "Amount"
      }
    ],
    "BidMin": [
      "BidMin",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "Amount"
      }
    ],
    "BidMax": [
      "BidMax",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "Amount"
      }
    ],
    "MinimumOffer": [
      "MinimumOffer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "Amount"
      }
    ],
    "RippleEscrow": [
      "RippleEscrow",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "Amount"
      }
    ],
    "DeliveredAmount": [
      "DeliveredAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "Amount"
      }
    ],
    "NFTokenBrokerFee": [
      "NFTokenBrokerFee",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "Amount"
      }
    ],
    "BaseFeeDrops": [
      "BaseFeeDrops",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "Amount"
      }
    ],
    "ReserveBaseDrops": [
      "ReserveBaseDrops",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 23,
        "type": "Amount"
      }
    ],
    "ReserveIncrementDrops": [
      "ReserveIncrementDrops",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "Amount"
      }
    ],
    "LPTokenOut": [
      "LPTokenOut",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "Amount"
      }
    ],
    "LPTokenIn": [
      "LPTokenIn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "Amount"
      }
    ],
    "EPrice": [
      "EPrice",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "Amount"
      }
    ],
    "Price": [
      "Price",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "Amount"
      }
    ],
    "SignatureReward": [
      "SignatureReward",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "Amount"
      }
    ],
    "MinAccountCreateAmount": [
      "MinAccountCreateAmount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 30,
        "type": "Amount"
      }
    ],
    "LPTokenBalance": [
      "LPTokenBalance",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 31,
        "type": "Amount"
      }
    ],
    "PublicKey": [
      "PublicKey",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 1,
        "type": "Blob"
      }
    ],
    "MessageKey": [
      "MessageKey",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 2,
        "type": "Blob"
      }
    ],
    "SigningPubKey": [
      "SigningPubKey",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 3,
        "type": "Blob"
      }
    ],
    "TxnSignature": [
      "TxnSignature",
      {
        "isSerialized": true,
        "isSigningField": false,
        "isVLEncoded": true,
        "nth": 4,
        "type": "Blob"
      }
    ],
    "URI": [
      "URI",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 5,
        "type": "Blob"
      }
    ],
    "Signature": [
      "Signature",
      {
        "isSerialized": true,
        "isSigningField": false,
        "isVLEncoded": true,
        "nth": 6,
        "type": "Blob"
      }
    ],
    "Domain": [
      "Domain",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 7,
        "type": "Blob"
      }
    ],
    "FundCode": [
      "FundCode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 8,
        "type": "Blob"
      }
    ],
    "RemoveCode": [
      "RemoveCode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 9,
        "type": "Blob"
      }
    ],
    "ExpireCode": [
      "ExpireCode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 10,
        "type": "Blob"
      }
    ],
    "CreateCode": [
      "CreateCode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 11,
        "type": "Blob"
      }
    ],
    "MemoType": [
      "MemoType",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 12,
        "type": "Blob"
      }
    ],
    "MemoData": [
      "MemoData",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 13,
        "type": "Blob"
      }
    ],
    "MemoFormat": [
      "MemoFormat",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 14,
        "type": "Blob"
      }
    ],
    "Fulfillment": [
      "Fulfillment",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 16,
        "type": "Blob"
      }
    ],
    "Condition": [
      "Condition",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 17,
        "type": "Blob"
      }
    ],
    "MasterSignature": [
      "MasterSignature",
      {
        "isSerialized": true,
        "isSigningField": false,
        "isVLEncoded": true,
        "nth": 18,
        "type": "Blob"
      }
    ],
    "UNLModifyValidator": [
      "UNLModifyValidator",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 19,
        "type": "Blob"
      }
    ],
    "ValidatorToDisable": [
      "ValidatorToDisable",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 20,
        "type": "Blob"
      }
    ],
    "ValidatorToReEnable": [
      "ValidatorToReEnable",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 21,
        "type": "Blob"
      }
    ],
    "HookStateData": [
      "HookStateData",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 22,
        "type": "Blob"
      }
    ],
    "HookReturnString": [
      "HookReturnString",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 23,
        "type": "Blob"
      }
    ],
    "HookParameterName": [
      "HookParameterName",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 24,
        "type": "Blob"
      }
    ],
    "HookParameterValue": [
      "HookParameterValue",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 25,
        "type": "Blob"
      }
    ],
    "DIDDocument": [
      "DIDDocument",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 26,
        "type": "Blob"
      }
    ],
    "Data": [
      "Data",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 27,
        "type": "Blob"
      }
    ],
    "AssetClass": [
      "AssetClass",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 28,
        "type": "Blob"
      }
    ],
    "Provider": [
      "Provider",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 29,
        "type": "Blob"
      }
    ],
    "MPTokenMetadata": [
      "MPTokenMetadata",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 30,
        "type": "Blob"
      }
    ],
    "CredentialType": [
      "CredentialType",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 31,
        "type": "Blob"
      }
    ],
    "Account": [
      "Account",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 1,
        "type": "AccountID"
      }
    ],
    "Owner": [
      "Owner",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 2,
        "type": "AccountID"
      }
    ],
    "Destination": [
      "Destination",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 3,
        "type": "AccountID"
      }
    ],
    "Issuer": [
      "Issuer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 4,
        "type": "AccountID"
      }
    ],
    "Authorize": [
      "Authorize",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 5,
        "type": "AccountID"
      }
    ],
    "Unauthorize": [
      "Unauthorize",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 6,
        "type": "AccountID"
      }
    ],
    "RegularKey": [
      "RegularKey",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 8,
        "type": "AccountID"
      }
    ],
    "NFTokenMinter": [
      "NFTokenMinter",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 9,
        "type": "AccountID"
      }
    ],
    "EmitCallback": [
      "EmitCallback",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 10,
        "type": "AccountID"
      }
    ],
    "Holder": [
      "Holder",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 11,
        "type": "AccountID"
      }
    ],
    "Delegate": [
      "Delegate",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 12,
        "type": "AccountID"
      }
    ],
    "HookAccount": [
      "HookAccount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 16,
        "type": "AccountID"
      }
    ],
    "OtherChainSource": [
      "OtherChainSource",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 18,
        "type": "AccountID"
      }
    ],
    "OtherChainDestination": [
      "OtherChainDestination",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 19,
        "type": "AccountID"
      }
    ],
    "AttestationSignerAccount": [
      "AttestationSignerAccount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 20,
        "type": "AccountID"
      }
    ],
    "AttestationRewardAccount": [
      "AttestationRewardAccount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 21,
        "type": "AccountID"
      }
    ],
    "LockingChainDoor": [
      "LockingChainDoor",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 22,
        "type": "AccountID"
      }
    ],
    "IssuingChainDoor": [
      "IssuingChainDoor",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 23,
        "type": "AccountID"
      }
    ],
    "Subject": [
      "Subject",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 24,
        "type": "AccountID"
      }
    ],
    "Number": [
      "Number",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Number"
      }
    ],
    "AssetsAvailable": [
      "AssetsAvailable",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Number"
      }
    ],
    "AssetsMaximum": [
      "AssetsMaximum",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "Number"
      }
    ],
    "AssetsTotal": [
      "AssetsTotal",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "Number"
      }
    ],
    "LossUnrealized": [
      "LossUnrealized",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "Number"
      }
    ],
    "TransactionMetaData": [
      "TransactionMetaData",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "STObject"
      }
    ],
    "CreatedNode": [
      "CreatedNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "STObject"
      }
    ],
    "DeletedNode": [
      "DeletedNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "STObject"
      }
    ],
    "ModifiedNode": [
      "ModifiedNode",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "STObject"
      }
    ],
    "PreviousFields": [
      "PreviousFields",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "STObject"
      }
    ],
    "FinalFields": [
      "FinalFields",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "STObject"
      }
    ],
    "NewFields": [
      "NewFields",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "STObject"
      }
    ],
    "TemplateEntry": [
      "TemplateEntry",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "STObject"
      }
    ],
    "Memo": [
      "Memo",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "STObject"
      }
    ],
    "SignerEntry": [
      "SignerEntry",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "STObject"
      }
    ],
    "NFToken": [
      "NFToken",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "STObject"
      }
    ],
    "EmitDetails": [
      "EmitDetails",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "STObject"
      }
    ],
    "Hook": [
      "Hook",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 14,
        "type": "STObject"
      }
    ],
    "Permission": [
      "Permission",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 15,
        "type": "STObject"
      }
    ],
    "Signer": [
      "Signer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "STObject"
      }
    ],
    "Majority": [
      "Majority",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "STObject"
      }
    ],
    "DisabledValidator": [
      "DisabledValidator",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "STObject"
      }
    ],
    "EmittedTxn": [
      "EmittedTxn",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "STObject"
      }
    ],
    "HookExecution": [
      "HookExecution",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "STObject"
      }
    ],
    "HookDefinition": [
      "HookDefinition",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "STObject"
      }
    ],
    "HookParameter": [
      "HookParameter",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 23,
        "type": "STObject"
      }
    ],
    "HookGrant": [
      "HookGrant",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "STObject"
      }
    ],
    "VoteEntry": [
      "VoteEntry",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "STObject"
      }
    ],
    "AuctionSlot": [
      "AuctionSlot",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "STObject"
      }
    ],
    "AuthAccount": [
      "AuthAccount",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "STObject"
      }
    ],
    "XChainClaimProofSig": [
      "XChainClaimProofSig",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "STObject"
      }
    ],
    "XChainCreateAccountProofSig": [
      "XChainCreateAccountProofSig",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "STObject"
      }
    ],
    "XChainClaimAttestationCollectionElement": [
      "XChainClaimAttestationCollectionElement",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 30,
        "type": "STObject"
      }
    ],
    "XChainCreateAccountAttestationCollectionElement": [
      "XChainCreateAccountAttestationCollectionElement",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 31,
        "type": "STObject"
      }
    ],
    "PriceData": [
      "PriceData",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 32,
        "type": "STObject"
      }
    ],
    "Credential": [
      "Credential",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 33,
        "type": "STObject"
      }
    ],
    "RawTransaction": [
      "RawTransaction",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 34,
        "type": "STObject"
      }
    ],
    "BatchSigner": [
      "BatchSigner",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 35,
        "type": "STObject"
      }
    ],
    "Book": [
      "Book",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 36,
        "type": "STObject"
      }
    ],
    "Signers": [
      "Signers",
      {
        "isSerialized": true,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 3,
        "type": "STArray"
      }
    ],
    "SignerEntries": [
      "SignerEntries",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "STArray"
      }
    ],
    "Template": [
      "Template",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "STArray"
      }
    ],
    "Necessary": [
      "Necessary",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 6,
        "type": "STArray"
      }
    ],
    "Sufficient": [
      "Sufficient",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 7,
        "type": "STArray"
      }
    ],
    "AffectedNodes": [
      "AffectedNodes",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 8,
        "type": "STArray"
      }
    ],
    "Memos": [
      "Memos",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 9,
        "type": "STArray"
      }
    ],
    "NFTokens": [
      "NFTokens",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 10,
        "type": "STArray"
      }
    ],
    "Hooks": [
      "Hooks",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 11,
        "type": "STArray"
      }
    ],
    "VoteSlots": [
      "VoteSlots",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 12,
        "type": "STArray"
      }
    ],
    "AdditionalBooks": [
      "AdditionalBooks",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 13,
        "type": "STArray"
      }
    ],
    "Majorities": [
      "Majorities",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "STArray"
      }
    ],
    "DisabledValidators": [
      "DisabledValidators",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "STArray"
      }
    ],
    "HookExecutions": [
      "HookExecutions",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "STArray"
      }
    ],
    "HookParameters": [
      "HookParameters",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "STArray"
      }
    ],
    "HookGrants": [
      "HookGrants",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "STArray"
      }
    ],
    "XChainClaimAttestations": [
      "XChainClaimAttestations",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 21,
        "type": "STArray"
      }
    ],
    "XChainCreateAccountAttestations": [
      "XChainCreateAccountAttestations",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 22,
        "type": "STArray"
      }
    ],
    "PriceDataSeries": [
      "PriceDataSeries",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 24,
        "type": "STArray"
      }
    ],
    "AuthAccounts": [
      "AuthAccounts",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 25,
        "type": "STArray"
      }
    ],
    "AuthorizeCredentials": [
      "AuthorizeCredentials",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 26,
        "type": "STArray"
      }
    ],
    "UnauthorizeCredentials": [
      "UnauthorizeCredentials",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 27,
        "type": "STArray"
      }
    ],
    "AcceptedCredentials": [
      "AcceptedCredentials",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 28,
        "type": "STArray"
      }
    ],
    "Permissions": [
      "Permissions",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 29,
        "type": "STArray"
      }
    ],
    "RawTransactions": [
      "RawTransactions",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 30,
        "type": "STArray"
      }
    ],
    "BatchSigners": [
      "BatchSigners",
      {
        "isSerialized": true,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 31,
        "type": "STArray"
      }
    ],
    "CloseResolution": [
      "CloseResolution",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "UInt8"
      }
    ],
    "Method": [
      "Method",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "UInt8"
      }
    ],
    "TransactionResult": [
      "TransactionResult",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "UInt8"
      }
    ],
    "Scale": [
      "Scale",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "UInt8"
      }
    ],
    "AssetScale": [
      "AssetScale",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 5,
        "type": "UInt8"
      }
    ],
    "TickSize": [
      "TickSize",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 16,
        "type": "UInt8"
      }
    ],
    "UNLModifyDisabling": [
      "UNLModifyDisabling",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 17,
        "type": "UInt8"
      }
    ],
    "HookResult": [
      "HookResult",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 18,
        "type": "UInt8"
      }
    ],
    "WasLockingChainSend": [
      "WasLockingChainSend",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 19,
        "type": "UInt8"
      }
    ],
    "WithdrawalPolicy": [
      "WithdrawalPolicy",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 20,
        "type": "UInt8"
      }
    ],
    "TakerPaysCurrency": [
      "TakerPaysCurrency",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Hash160"
      }
    ],
    "TakerPaysIssuer": [
      "TakerPaysIssuer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Hash160"
      }
    ],
    "TakerGetsCurrency": [
      "TakerGetsCurrency",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "Hash160"
      }
    ],
    "TakerGetsIssuer": [
      "TakerGetsIssuer",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "Hash160"
      }
    ],
    "Paths": [
      "Paths",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "PathSet"
      }
    ],
    "Indexes": [
      "Indexes",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 1,
        "type": "Vector256"
      }
    ],
    "Hashes": [
      "Hashes",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 2,
        "type": "Vector256"
      }
    ],
    "Amendments": [
      "Amendments",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 3,
        "type": "Vector256"
      }
    ],
    "NFTokenOffers": [
      "NFTokenOffers",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 4,
        "type": "Vector256"
      }
    ],
    "CredentialIDs": [
      "CredentialIDs",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": true,
        "nth": 5,
        "type": "Vector256"
      }
    ],
    "MPTokenIssuanceID": [
      "MPTokenIssuanceID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Hash192"
      }
    ],
    "ShareMPTID": [
      "ShareMPTID",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Hash192"
      }
    ],
    "LockingChainIssue": [
      "LockingChainIssue",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Issue"
      }
    ],
    "IssuingChainIssue": [
      "IssuingChainIssue",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Issue"
      }
    ],
    "Asset": [
      "Asset",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 3,
        "type": "Issue"
      }
    ],
    "Asset2": [
      "Asset2",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 4,
        "type": "Issue"
      }
    ],
    "XChainBridge": [
      "XChainBridge",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "XChainBridge"
      }
    ],
    "BaseAsset": [
      "BaseAsset",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 1,
        "type": "Currency"
      }
    ],
    "QuoteAsset": [
      "QuoteAsset",
      {
        "isSerialized": true,
        "isSigningField": true,
        "isVLEncoded": false,
        "nth": 2,
        "type": "Currency"
      }
    ],
    "Transaction": [
      "Transaction",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 257,
        "type": "Transaction"
      }
    ],
    "LedgerEntry": [
      "LedgerEntry",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 257,
        "type": "LedgerEntry"
      }
    ],
    "Validation": [
      "Validation",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 257,
        "type": "Validation"
      }
    ],
    "Metadata": [
      "Metadata",
      {
        "isSerialized": false,
        "isSigningField": false,
        "isVLEncoded": false,
        "nth": 257,
        "type": "Metadata"
      }
    ]
  },
  "LEDGER_ENTRY_TYPES": {
    "AMM": 121,
    "AccountRoot": 97,
    "Amendments": 102,
    "Bridge": 105,
    "Check": 67,
    "Credential": 129,
    "DID": 73,
    "Delegate": 131,
    "DepositPreauth": 112,
    "DirectoryNode": 100,
    "Escrow": 117,
    "FeeSettings": 115,
    "Invalid": -1,
    "LedgerHashes": 104,
    "MPToken": 127,
    "MPTokenIssuance": 126,
    "NFTokenOffer": 55,
    "NFTokenPage": 80,
    "NegativeUNL": 78,
    "Offer": 111,
    "Oracle": 128,
    "PayChannel": 120,
    "PermissionedDomain": 130,
    "RippleState": 114,
    "SignerList": 83,
    "Ticket": 84,
    "Vault": 132,
    "XChainOwnedClaimID": 113,
    "XChainOwnedCreateAccountClaimID": 116
  },
  "TRANSACTION_RESULTS": {
    "tecAMM_ACCOUNT": 168,
    "tecAMM_BALANCE": 163,
    "tecAMM_EMPTY": 166,
    "tecAMM_FAILED": 164,
    "tecAMM_INVALID_TOKENS": 165,
    "tecAMM_NOT_EMPTY": 167,
    "tecARRAY_EMPTY": 190,
    "tecARRAY_TOO_LARGE": 191,
    "tecBAD_CREDENTIALS": 193,
    "tecCANT_ACCEPT_OWN_NFTOKEN_OFFER": 158,
    "tecCLAIM": 100,
    "tecCRYPTOCONDITION_ERROR": 146,
    "tecDIR_FULL": 121,
    "tecDST_TAG_NEEDED": 143,
    "tecDUPLICATE": 149,
    "tecEMPTY_DID": 187,
    "tecEXPIRED": 148,
    "tecFAILED_PROCESSING": 105,
    "tecFROZEN": 137,
    "tecHAS_OBLIGATIONS": 151,
    "tecHOOK_REJECTED": 153,
    "tecINCOMPLETE": 169,
    "tecINSUFFICIENT_FUNDS": 159,
    "tecINSUFFICIENT_PAYMENT": 161,
    "tecINSUFFICIENT_RESERVE": 141,
    "tecINSUFF_FEE": 136,
    "tecINSUF_RESERVE_LINE": 122,
    "tecINSUF_RESERVE_OFFER": 123,
    "tecINTERNAL": 144,
    "tecINVALID_UPDATE_TIME": 188,
    "tecINVARIANT_FAILED": 147,
    "tecKILLED": 150,
    "tecLIMIT_EXCEEDED": 195,
    "tecLOCKED": 192,
    "tecMAX_SEQUENCE_REACHED": 154,
    "tecNEED_MASTER_KEY": 142,
    "tecNFTOKEN_BUY_SELL_MISMATCH": 156,
    "tecNFTOKEN_OFFER_TYPE_MISMATCH": 157,
    "tecNO_ALTERNATIVE_KEY": 130,
    "tecNO_AUTH": 134,
    "tecNO_DELEGATE_PERMISSION": 198,
    "tecNO_DST": 124,
    "tecNO_DST_INSUF_XRP": 125,
    "tecNO_ENTRY": 140,
    "tecNO_ISSUER": 133,
    "tecNO_LINE": 135,
    "tecNO_LINE_INSUF_RESERVE": 126,
    "tecNO_LINE_REDUNDANT": 127,
    "tecNO_PERMISSION": 139,
    "tecNO_REGULAR_KEY": 131,
    "tecNO_SUITABLE_NFTOKEN_PAGE": 155,
    "tecNO_TARGET": 138,
    "tecOBJECT_NOT_FOUND": 160,
    "tecOVERSIZE": 145,
    "tecOWNERS": 132,
    "tecPATH_DRY": 128,
    "tecPATH_PARTIAL": 101,
    "tecPRECISION_LOSS": 197,
    "tecPSEUDO_ACCOUNT": 196,
    "tecTOKEN_PAIR_NOT_FOUND": 189,
    "tecTOO_SOON": 152,
    "tecUNFUNDED": 129,
    "tecUNFUNDED_ADD": 102,
    "tecUNFUNDED_AMM": 162,
    "tecUNFUNDED_OFFER": 103,
    "tecUNFUNDED_PAYMENT": 104,
    "tecWRONG_ASSET": 194,
    "tecXCHAIN_ACCOUNT_CREATE_PAST": 181,
    "tecXCHAIN_ACCOUNT_CREATE_TOO_MANY": 182,
    "tecXCHAIN_BAD_CLAIM_ID": 172,
    "tecXCHAIN_BAD_PUBLIC_KEY_ACCOUNT_PAIR": 185,
    "tecXCHAIN_BAD_TRANSFER_ISSUE": 170,
    "tecXCHAIN_CLAIM_NO_QUORUM": 173,
    "tecXCHAIN_CREATE_ACCOUNT_DISABLED": 186,
    "tecXCHAIN_CREATE_ACCOUNT_NONXRP_ISSUE": 175,
    "tecXCHAIN_INSUFF_CREATE_AMOUNT": 180,
    "tecXCHAIN_NO_CLAIM_ID": 171,
    "tecXCHAIN_NO_SIGNERS_LIST": 178,
    "tecXCHAIN_PAYMENT_FAILED": 183,
    "tecXCHAIN_PROOF_UNKNOWN_KEY": 174,
    "tecXCHAIN_REWARD_MISMATCH": 177,
    "tecXCHAIN_SELF_COMMIT": 184,
    "tecXCHAIN_SENDING_ACCOUNT_MISMATCH": 179,
    "tecXCHAIN_WRONG_CHAIN": 176,
    "tefALREADY": -198,
    "tefBAD_ADD_AUTH": -197,
    "tefBAD_AUTH": -196,
    "tefBAD_AUTH_MASTER": -183,
    "tefBAD_LEDGER": -195,
    "tefBAD_QUORUM": -185,
    "tefBAD_SIGNATURE": -186,
    "tefCREATED": -194,
    "tefEXCEPTION": -193,
    "tefFAILURE": -199,
    "tefINTERNAL": -192,
    "tefINVALID_LEDGER_FIX_TYPE": -178,
    "tefINVARIANT_FAILED": -182,
    "tefMASTER_DISABLED": -188,
    "tefMAX_LEDGER": -187,
    "tefNFTOKEN_IS_NOT_TRANSFERABLE": -179,
    "tefNOT_MULTI_SIGNING": -184,
    "tefNO_AUTH_REQUIRED": -191,
    "tefNO_TICKET": -180,
    "tefPAST_SEQ": -190,
    "tefTOO_BIG": -181,
    "tefWRONG_PRIOR": -189,
    "telBAD_DOMAIN": -398,
    "telBAD_PATH_COUNT": -397,
    "telBAD_PUBLIC_KEY": -396,
    "telCAN_NOT_QUEUE": -392,
    "telCAN_NOT_QUEUE_BALANCE": -391,
    "telCAN_NOT_QUEUE_BLOCKED": -389,
    "telCAN_NOT_QUEUE_BLOCKS": -390,
    "telCAN_NOT_QUEUE_FEE": -388,
    "telCAN_NOT_QUEUE_FULL": -387,
    "telENV_RPC_FAILED": -383,
    "telFAILED_PROCESSING": -395,
    "telINSUF_FEE_P": -394,
    "telLOCAL_ERROR": -399,
    "telNETWORK_ID_MAKES_TX_NON_CANONICAL": -384,
    "telNO_DST_PARTIAL": -393,
    "telREQUIRES_NETWORK_ID": -385,
    "telWRONG_NETWORK": -386,
    "temARRAY_EMPTY": -253,
    "temARRAY_TOO_LARGE": -252,
    "temBAD_AMM_TOKENS": -261,
    "temBAD_AMOUNT": -298,
    "temBAD_CURRENCY": -297,
    "temBAD_EXPIRATION": -296,
    "temBAD_FEE": -295,
    "temBAD_ISSUER": -294,
    "temBAD_LIMIT": -293,
    "temBAD_NFTOKEN_TRANSFER_FEE": -262,
    "temBAD_OFFER": -292,
    "temBAD_PATH": -291,
    "temBAD_PATH_LOOP": -290,
    "temBAD_QUORUM": -271,
    "temBAD_REGKEY": -289,
    "temBAD_SEND_XRP_LIMIT": -288,
    "temBAD_SEND_XRP_MAX": -287,
    "temBAD_SEND_XRP_NO_DIRECT": -286,
    "temBAD_SEND_XRP_PARTIAL": -285,
    "temBAD_SEND_XRP_PATHS": -284,
    "temBAD_SEQUENCE": -283,
    "temBAD_SIGNATURE": -282,
    "temBAD_SIGNER": -272,
    "temBAD_SRC_ACCOUNT": -281,
    "temBAD_TICK_SIZE": -269,
    "temBAD_TRANSFER_FEE": -251,
    "temBAD_TRANSFER_RATE": -280,
    "temBAD_WEIGHT": -270,
    "temCANNOT_PREAUTH_SELF": -267,
    "temDISABLED": -273,
    "temDST_IS_SRC": -279,
    "temDST_NEEDED": -278,
    "temEMPTY_DID": -254,
    "temINVALID": -277,
    "temINVALID_ACCOUNT_ID": -268,
    "temINVALID_COUNT": -266,
    "temINVALID_FLAG": -276,
    "temINVALID_INNER_BATCH": -250,
    "temMALFORMED": -299,
    "temREDUNDANT": -275,
    "temRIPPLE_EMPTY": -274,
    "temSEQ_AND_TICKET": -263,
    "temUNCERTAIN": -265,
    "temUNKNOWN": -264,
    "temXCHAIN_BAD_PROOF": -259,
    "temXCHAIN_BRIDGE_BAD_ISSUES": -258,
    "temXCHAIN_BRIDGE_BAD_MIN_ACCOUNT_CREATE_AMOUNT": -256,
    "temXCHAIN_BRIDGE_BAD_REWARD_AMOUNT": -255,
    "temXCHAIN_BRIDGE_NONDOOR_OWNER": -257,
    "temXCHAIN_EQUAL_DOOR_ACCOUNTS": -260,
    "terADDRESS_COLLISION": -86,
    "terFUNDS_SPENT": -98,
    "terINSUF_FEE_B": -97,
    "terLAST": -91,
    "terNO_ACCOUNT": -96,
    "terNO_AMM": -87,
    "terNO_AUTH": -95,
    "terNO_LINE": -94,
    "terNO_RIPPLE": -90,
    "terOWNERS": -93,
    "terPRE_SEQ": -92,
    "terPRE_TICKET": -88,
    "terQUEUED": -89,
    "terRETRY": -99,
    "tesSUCCESS": 0
  },
  "TRANSACTION_TYPES": {
    "AMMBid": 39,
    "AMMClawback": 31,
    "AMMCreate": 35,
    "AMMDelete": 40,
    "AMMDeposit": 36,
    "AMMVote": 38,
    "AMMWithdraw": 37,
    "AccountDelete": 21,
    "AccountSet": 3,
    "Batch": 71,
    "CheckCancel": 18,
    "CheckCash": 17,
    "CheckCreate": 16,
    "Clawback": 30,
    "CredentialAccept": 59,
    "CredentialCreate": 58,
    "CredentialDelete": 60,
    "DIDDelete": 50,
    "DIDSet": 49,
    "DelegateSet": 64,
    "DepositPreauth": 19,
    "EnableAmendment": 100,
    "EscrowCancel": 4,
    "EscrowCreate": 1,
    "EscrowFinish": 2,
    "Invalid": -1,
    "LedgerStateFix": 53,
    "MPTokenAuthorize": 57,
    "MPTokenIssuanceCreate": 54,
    "MPTokenIssuanceDestroy": 55,
    "MPTokenIssuanceSet": 56,
    "NFTokenAcceptOffer": 29,
    "NFTokenBurn": 26,
    "NFTokenCancelOffer": 28,
    "NFTokenCreateOffer": 27,
    "NFTokenMint": 25,
    "NFTokenModify": 61,
    "OfferCancel": 8,
    "OfferCreate": 7,
    "OracleDelete": 52,
    "OracleSet": 51,
    "Payment": 0,
    "PaymentChannelClaim": 15,
    "PaymentChannelCreate": 13,
    "PaymentChannelFund": 14,
    "PermissionedDomainDelete": 63,
    "PermissionedDomainSet": 62,
    "SetFee": 101,
    "SetRegularKey": 5,
    "SignerListSet": 12,
    "TicketCreate": 10,
    "TrustSet": 20,
    "UNLModify": 102,
    "VaultClawback": 70,
    "VaultCreate": 65,
    "VaultDelete": 67,
    "VaultDeposit": 68,
    "VaultSet": 66,
    "VaultWithdraw": 69,
    "XChainAccountCreateCommit": 44,
    "XChainAddAccountCreateAttestation": 46,
    "XChainAddClaimAttestation": 45,
    "XChainClaim": 43,
    "XChainCommit": 42,
    "XChainCreateBridge": 48,
    "XChainCreateClaimID": 41,
    "XChainModifyBridge": 47
  },
  "TYPES": {
    "AccountID": 8,
    "Amount": 6,
    "Blob": 7,
    "Currency": 26,
    "Done": -1,
    "Hash128": 4,
    "Hash160": 17,
    "Hash192": 21,
    "Hash256": 5,
    "Issue": 24,
    "LedgerEntry": 10002,
    "Metadata": 10004,
    "NotPresent": 0,
    "Number": 9,
    "PathSet": 18,
    "STArray": 15,
    "STObject": 14,
    "Transaction": 10001,
    "UInt16": 1,
    "UInt32": 2,
    "UInt384": 22,
    "UInt512": 23,
    "UInt64": 3,
    "UInt8": 16,
    "UInt96": 20,
    "Unknown": -2,
    "Validation": 10003,
    "Vector256": 19,
    "XChainBridge": 25
  }
};
