import 'package:test/test.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void newRpcMethodsTest() {

  test("new RPC request params", () {
    final feature = XRPRequestFeature(feature: "DynamicNFT");
    expect(feature.method, "feature");
    expect(feature.toJson(), {"feature": "DynamicNFT"});
    final featureAll = XRPRequestFeature();
    expect(featureAll.toJson(), {"feature": null});

    final sign = XRPRequestSign(
      txJson: {
        "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
        "TransactionType": "Payment",
      },
    );
    expect(sign.method, "sign");
    expect(sign.toJson()["tx_json"]["TransactionType"], "Payment");

    final signFor = XRPRequestSignFor(
      account: "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      txJson: {
        "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
        "TransactionType": "Payment",
      },
    );
    expect(signFor.method, "sign_for");

    final vaultInfo = XRPRequestVaultInfo(vaultId: "9E48");
    expect(vaultInfo.method, "vault_info");
    expect(vaultInfo.toJson()["vault_id"], "9E48");

    final byIssuer = XRPRequestNFTsByIssuer(issuer: "rLaBCoaMQqXzHDmiGs2Qv2JA2bg3Yvzxyt");
    expect(byIssuer.method, "nfts_by_issuer");
    expect(byIssuer.toJson()["issuer"], "rLaBCoaMQqXzHDmiGs2Qv2JA2bg3Yvzxyt");

    final mptokens = XRPRequestAccountMPTokens(account: "rLEw4taUYTNLs3ZCv3vyXGmct8PagQ9GcF");
    expect(mptokens.method, "account_mptokens");

    final issuances = XRPRequestAccountMPTokenIssuances(
      account: "rExB3uFDE92wKYP6vfjt31Lbi6tXpFobUT",
    );
    expect(issuances.method, "account_mptoken_issuances");

    final holders = XRPRequestMPTHolders(mptIssuanceId: "05EE");
    expect(holders.method, "mpt_holders");
    expect(holders.toJson()["mpt_issuance_id"], "05EE");

    final List<XRPLedgerRequest<dynamic, Map<String, dynamic>>> requests = [
      feature,
      sign,
      signFor,
      vaultInfo,
      byIssuer,
      mptokens,
      issuances,
      holders,
    ];
    for (final request in requests) {
      final built = request.buildRequest(0);
      expect(built.method, request.method);
      final back = XRPRequestDetails.deserialize(
        bytes: built.toCbor().encode(),
      );
      expect(back.method, request.method);
    }
  });

  test("feature response", () {
    final result = FeatureResult.fromJson({
      "4C97EBA926031A7CF7D7B36FDE3ED66DDA5421192D63DE53FFB46E43B9DC8373": {
        "enabled": false,
        "name": "MultiSign",
        "supported": true,
      },
    });
    expect(result.features.length, 1);
    expect(result.features.values.first.name, "MultiSign");
    expect(result.features.values.first.enabled, isFalse);
    expect(
      FeatureResult.fromJson(result.toJson()).features.keys.first,
      result.features.keys.first,
    );
  });

  test("vault_info response", () {
    final result = VaultInfoResult.fromJson({
      "ledger_index": 3279463,
      "validated": true,
      "vault": {
        "Account": "rQhUcbJoDfvgXr1EkMwarLP5QT3XinEBDg",
        "LedgerEntryType": "Vault",
        "Owner": "rJdYtgaiEgzL7xD2QdPKg5xoHkWc7CZjvm",
        "Sequence": 3113728,
        "ShareMPTID": "00000001FCE5D5E313303F3D0C700789108CC6BE7D711493",
        "WithdrawalPolicy": 1,
        "index": "9E48171960CD9F62C3A7B6559315A510AE544C3F51E02947B5D4DAC8AA66C3BA",
        "Asset": {
          "mpt_issuance_id": "002F830036E4E56185F871D70CFFC7BDD554F897606BB6D3",
        },
        "shares": {
          "Issuer": "rQhUcbJoDfvgXr1EkMwarLP5QT3XinEBDg",
          "LedgerEntryType": "MPTokenIssuance",
          "Sequence": 1,
          "index": "F231A0382544EC0ABE810A9D292F3BD455A21CD13CC1DFF75EAFE957A1C8CAB4",
          "mpt_issuance_id":
              "00000001FCE5D5E313303F3D0C700789108CC6BE7D711493",
        },
      },
    });
    expect(result.validated, isTrue);
    expect(result.vault?.account, "rQhUcbJoDfvgXr1EkMwarLP5QT3XinEBDg");
    expect(
      result.vault?.asset?.mptIssuanceId,
      "002F830036E4E56185F871D70CFFC7BDD554F897606BB6D3",
    );
    expect(result.vault?.shares?.sequence, 1);
    expect(
      VaultInfoResult.fromJson(result.toJson()).vault?.shareMPTID,
      "00000001FCE5D5E313303F3D0C700789108CC6BE7D711493",
    );
  });

  test("nfts_by_issuer response", () {
    final result = NFTsByIssuerResult.fromJson({
      "issuer": "rfXeQv31yWMrhhPxMHZRzQqhw5mQrcuici",
      "limit": 50,
      "ledger_index": 1534,
      "validated": true,
      "nfts": [
        {
          "nft_id":
              "00080000479C76BC5174816A938ABF667E67D851140BFE03F068FA97000005FB",
          "ledger_index": 1533,
          "owner": "rfXeQv31yWMrhhPxMHZRzQqhw5mQrcuici",
          "is_burned": false,
          "uri": "",
          "flags": 8,
          "transfer_fee": 0,
          "issuer": "rfXeQv31yWMrhhPxMHZRzQqhw5mQrcuici",
          "nft_taxon": 1,
          "nft_serial": 1531,
        },
      ],
    });
    expect(result.nfts.length, 1);
    expect(result.nfts.first.nftSerial, 1531);
    expect(
      NFTsByIssuerResult.fromJson(result.toJson()).nfts.first.nftId,
      result.nfts.first.nftId,
    );
  });

  test("mpt responses", () {
    final tokens = AccountMPTokensResult.fromJson({
      "account": "rLEw4taUYTNLs3ZCv3vyXGmct8PagQ9GcF",
      "limit": 200,
      "ledger_index": 99563041,
      "validated": true,
      "mptokens": [
        {
          "mpt_id": "abc",
          "account": "rLEw4taUYTNLs3ZCv3vyXGmct8PagQ9GcF",
          "mpt_issuance_id": "05EE",
          "mpt_amount": 100,
        },
      ],
    });
    expect(tokens.mptokens.first.mptAmount, "100");
    expect(
      AccountMPTokensResult.fromJson(tokens.toJson()).mptokens.length,
      1,
    );

    final issuances = AccountMPTokenIssuancesResult.fromJson({
      "account": "rExB3uFDE92wKYP6vfjt31Lbi6tXpFobUT",
      "limit": 200,
      "ledger_index": 99563041,
      "validated": true,
      "mpt_issuances": [
        {
          "mpt_issuance_id": "05EE",
          "issuer": "rExB3uFDE92wKYP6vfjt31Lbi6tXpFobUT",
          "sequence": 1,
          "mpt_can_transfer": true,
        },
      ],
    });
    expect(issuances.mptIssuances.first.mptCanTransfer, isTrue);
    expect(
      AccountMPTokenIssuancesResult.fromJson(
        issuances.toJson(),
      ).mptIssuances.length,
      1,
    );

    final holders = MPTHoldersResult.fromJson({
      "mpt_issuance_id": "05EE",
      "limit": 50,
      "ledger_index": 99563041,
      "validated": true,
      "mptokens": [
        {
          "account": "rsNw23ygZatXv7h8QVSgAE4jktY2uW1iZP",
          "flags": 0,
          "mpt_amount": "100",
          "mptoken_index": "081078D38E9C36647B4AD95ECB476F434B817753AD4F6B4B5EE0ED4C3185C80F",
        },
      ],
    });
    expect(holders.mptokens.first.account, "rsNw23ygZatXv7h8QVSgAE4jktY2uW1iZP");
    expect(
      MPTHoldersResult.fromJson(holders.toJson()).mptokens.length,
      1,
    );
  });

  test("sign responses", () {
    const txJson = {
      "Account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "TransactionType": "Payment",
      "Destination": "ra5nK24KXen9AHvsdFTKHSANinZseWnPcX",
      "Amount": "10000",
      "Fee": "12",
      "Sequence": 2,
    };
    final sign = SignResult.fromJson({"tx_json": txJson, "tx_blob": "1200"});
    expect(sign.txBlob, "1200");
    expect(sign.txJson.transactionType, SubmittableTransactionType.payment);
    expect(
      SignResult.fromJson(sign.toJson()).txBlob,
      "1200",
    );
    final signFor = SignForResult.fromJson({"tx_json": txJson});
    expect(
      signFor.txJson.transactionType,
      SubmittableTransactionType.payment,
    );
  });
}

void main() {
  XrplTestApi.runTest(newRpcMethodsTest, 'New Rpc Methods');
}
