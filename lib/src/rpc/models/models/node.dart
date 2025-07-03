enum XRPNodeType {
  createdNode("CreatedNode"),
  modifiedNode("ModifiedNode"),
  deletedNode("DeletedNode");

  const XRPNodeType(this.value);

  static XRPNodeType fromValue(String? name) {
    return values.firstWhere((e) => e.value == name);
  }

  final String value;
}

abstract class XRPNode {
  final XRPNodeType type;
  const XRPNode({required this.type});
  factory XRPNode.fromJson(Map<String, dynamic> json) {
    final type = XRPNodeType.fromValue(json.keys.firstOrNull);
    switch (type) {
      case XRPNodeType.createdNode:
        return CreatedNode.fromJson(json);
      case XRPNodeType.modifiedNode:
        return ModifiedNode.fromJson(json);
      case XRPNodeType.deletedNode:
        return DeletedNode.fromJson(json);
    }
  }
  Map<String, dynamic> toJson();
}

class CreatedNode extends XRPNode {
  final String ledgerEntryType;
  final String ledgerIndex;
  final Map<String, dynamic> newFields;

  CreatedNode({
    required this.ledgerEntryType,
    required this.ledgerIndex,
    required this.newFields,
  }) : super(type: XRPNodeType.createdNode);

  factory CreatedNode.fromJson(Map<String, dynamic> json) {
    final data = json['CreatedNode'] as Map<String, dynamic>;
    return CreatedNode(
      ledgerEntryType: data['LedgerEntryType'],
      ledgerIndex: data['LedgerIndex'],
      newFields: Map<String, dynamic>.from(data['NewFields']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'CreatedNode': {
          'LedgerEntryType': ledgerEntryType,
          'LedgerIndex': ledgerIndex,
          'NewFields': newFields,
        }
      };
}

class ModifiedNode extends XRPNode {
  final String ledgerEntryType;
  final String ledgerIndex;
  final Map<String, dynamic>? finalFields;
  final Map<String, dynamic>? previousFields;
  final String? previousTxnID;
  final int? previousTxnLgrSeq;

  ModifiedNode({
    required this.ledgerEntryType,
    required this.ledgerIndex,
    this.finalFields,
    this.previousFields,
    this.previousTxnID,
    this.previousTxnLgrSeq,
  }) : super(type: XRPNodeType.modifiedNode);

  factory ModifiedNode.fromJson(Map<String, dynamic> json) {
    final data = json['ModifiedNode'] as Map<String, dynamic>;
    return ModifiedNode(
      ledgerEntryType: data['LedgerEntryType'],
      ledgerIndex: data['LedgerIndex'],
      finalFields: data['FinalFields'] != null
          ? Map<String, dynamic>.from(data['FinalFields'])
          : null,
      previousFields: data['PreviousFields'] != null
          ? Map<String, dynamic>.from(data['PreviousFields'])
          : null,
      previousTxnID: data['PreviousTxnID'],
      previousTxnLgrSeq: data['PreviousTxnLgrSeq'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'ModifiedNode': {
          'LedgerEntryType': ledgerEntryType,
          'LedgerIndex': ledgerIndex,
          'FinalFields': finalFields,
          'PreviousFields': previousFields,
          'PreviousTxnID': previousTxnID,
          'PreviousTxnLgrSeq': previousTxnLgrSeq,
        }
      };
}

class DeletedNode extends XRPNode {
  final String ledgerEntryType;
  final String ledgerIndex;
  final Map<String, dynamic>? previousFields;
  final Map<String, dynamic> finalFields;

  DeletedNode({
    required this.ledgerEntryType,
    required this.ledgerIndex,
    this.previousFields,
    required this.finalFields,
  }) : super(type: XRPNodeType.deletedNode);

  factory DeletedNode.fromJson(Map<String, dynamic> json) {
    final data = json['DeletedNode'] as Map<String, dynamic>;
    return DeletedNode(
      ledgerEntryType: data['LedgerEntryType'],
      ledgerIndex: data['LedgerIndex'],
      previousFields: data['PreviousFields'] != null
          ? Map<String, dynamic>.from(data['PreviousFields'])
          : null,
      finalFields: Map<String, dynamic>.from(data['FinalFields']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'DeletedNode': {
          'LedgerEntryType': ledgerEntryType,
          'LedgerIndex': ledgerIndex,
          'PreviousFields': previousFields,
          'FinalFields': finalFields,
        }
      };
}
