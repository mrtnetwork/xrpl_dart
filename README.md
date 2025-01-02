# XRPL Dart Package

This package offers comprehensive functionality for signing XRP transactions using two prominent cryptographic algorithms, ED25519 and SECP256K1. Beyond transaction signing, it provides support for various features, including JSON-RPC, socket, and HTTP interactions. This versatility empowers developers to securely create, sign, and interact with XRP transactions.

For BIP32 HD wallet, BIP39, and Secret storage definitions, please refer to the [blockchain_utils](https://github.com/mrtnetwork/blockchain_utils) package.

## Features

### Transaction Types

The XRP Ledger accommodates a diverse range of transaction types, each tailored for specific purposes. Some of these are outlined below:

- Payment Transactions: Standard transactions used to send XRP or Issue from one address to another.
- Escrow Transactions: These transactions lock up XRP until certain conditions are met, providing a trustless way to facilitate delayed payments.
- TrustSet Transactions: Used to create or modify trust lines, enabling users to hold and trade assets other than XRP on the ledger.
- OrderBook Transactions: Used to place and cancel offers on the decentralized exchange within the XRP Ledger.
- PaymentChannel Transactions: Allow for off-chain payments using payment channels.
- NFT: Mint NFTs, cancel them, create offers, and seamlessly accept NFT offers.
- Issue: Issue custom assets.
- Automated Market Maker: Operations like bidding, creation, deletion, deposits, and voting.
- RegularKey: Transactions to set or update account regular keys.
- Offer: Creation and cancellation.
- Multi-signature Transaction: Transactions requiring multiple signatures for validation.
- XChainAccountCreateCommit: Creates a new account on one of the chains a bridge connects.
- XChainAddAccountCreateAttestation: Transaction provides an attestation from a witness server that an XChainAccountCreateCommit - - transaction occurred on the other chain.
- XChainAddClaimAttestation: Transaction provides proof from a witness server, attesting to an XChainCommit transaction.
- XChainClaim: Transaction completes a cross-chain transfer of value.
- XChainCreateBridge: Transaction creates a new Bridge ledger.
...

### Addresses

- classAddress: They are straightforward representations of the recipient's address on the XRP Ledger
- xAddress: newer format, which provides additional features and interoperability. xAddresses include destination tags by default and are designed to simplify cross-network transactions and improve address interoperability

### Sign

- Sign XRP transactions with ED25519 and SECP256K1 algorithms.

### JSON-RPC Support

This package streamlines communication with XRP nodes using both the JSON-RPC protocol and WebSocket technology. While endeavors have been undertaken to integrate all methods into RPC, it's crucial to acknowledge that, currently, the majority of data APIs are presented in JSON format and haven't been entirely modeled. The addition of WebSocket support enhances the package's versatility for real-time and asynchronous interactions with XRP nodes.

## EXAMPLES

Discover at least one example for each transaction type in the [examples](https://github.com/mrtnetwork/xrpl_dart/tree/main/example/lib) folder.

### Key and addresses

```dart
  /// create random privateKey
  final randomPrivate =
      XRPPrivateKey.random(algorithm: CryptoAlgorithm.SECP256K1);
  final toHex = randomPrivate.toHex();
  
  /// access private key with hex
  final private = XRPPrivateKey.fromHex(toHex);

  /// accesss publicKey
  final publicKey = private.getPublic();

  final addressClass = publicKey.toAddress();

  /// rpjEqWDFtoin7fFxuw6oQG2onkZkf72hhc
  final classicAddress = addressClass.address;

  /// X7ZBWLX4XnxEwvQa4sgH11QbhQzuTuGeoZKEb2naE92oNEc
  final xAddress = addressClass.toXAddress(isTestNetwork: false);

  /// sign with privateKey
  final sig = private.sign(...)
  
```

### Transaction

Every transaction type has a dedicated class for transaction creation.
Descriptions for some of these classes are outlined below.
Explore training examples for each transaction type in the examples folder [here](https://github.com/mrtnetwork/xrpl_dart/tree/main/example/lib/examples).

- Simple payment
  
  ```dart
    final transaction = Payment(
      destination: destination, // destination account
      account: ownerAddress, // Sender account
      amount: amount, // The amount sent can be in XRP or any other token.
      signingPubKey: ownerPublic); // Sender's public key

  ```

- NTF, mint, createOffer, acceptOffer

  ```dart
  // mint token
  final transaction = NFTokenMint(
      flags: NFTokenMintFlag.TF_TRANSFERABLE.value,
      account: ownerAddress,
      uri: "...", // that points to the data and/or metadata associated with the NFT
      signingPubKey: ownerPublic,
      memos: [memo], // Additional arbitrary information attached to this transaction
      nftokenTaxon: 1); // Indicates the taxon associated with this token

  // create offer
  final offer = NFTokenCreateOffer(
    amount: CurrencyAmount.xrp(BigInt.from(1000000)),
    flags: NFTokenCreateOfferFlag.TF_SELL_NFTOKEN.value,
    nftokenId: tokenId, /// Identifies the TokenID of the NFToken object that the offer references. 
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  
  // accept offer
  final offer = NFTokenAcceptOffer(
    nfTokenSellOffer: offerId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );

  ```

- Completely create, sign, and send transactions

  ```dart
  // create escrowCreate transaction
  final escrowCreate = EscrowCreate(
    account: ownerAddress,
    destination: destination,
    cancelAfterTime: cancelAfterOnDay,
    finishAfterTime: finishAfterOneHours,
    amount: BigInt.from(25000000),
    condition:
        "A0258020E488CD4C1AC9A7673CA2D2712B47049B87C308181BF3B89D6FBB74FC36836BB5810120",
    signingPubKey: ownerPublic,
    memos: [memo],
  );

  // It receives the transaction, the RPC class, and then fulfills the transaction requirements, including the fee amount, account sequence, and the last network ledger sequence.
  await autoFill(rpc, escrowCreate);
  
  // At this point, we need to sign the transaction with the sender's account.
  // We receive the transaction blob and sign it with the sender's private key.
  final sig = owner.sign(escrowCreate.toBlob());
  // After completing the signature, we add it to the transaction.
  escrowCreate.setSignature(sig);

  /// In the final step, we need to send the transaction to the network.
  /// We receive another transaction blob that already contains a signature. At this point, we no longer need to include a signature, and we must set the 'forSigning' variable to false.
  final trBlob = escrowCreate.toBlob(forSigning: false);

  // broadcasting transaction
  final result = await rpc.submit(trBlob)
  // transaction hash: result.txJson.hash ()
  // engine result: result.engineResult result.engineResult
  // engine result message: result.engineResultMessage
  
  ```

### JSON-RPC

Check out the [http_service](https://github.com/mrtnetwork/xrpl_dart/blob/main/example/lib/socket_rpc_example/http_service.dart) and [socket_service](https://github.com/mrtnetwork/xrpl_dart/blob/main/example/lib/socket_rpc_example/socket_service.dart) files to learn how to create an HTTP/WEBSOCKET RPC service.

- HTTP JSON RPC

```dart
  /// access devent
  final rpc = await XRPProvider.devNet((httpUri, websocketUri) async {
    service = RPCHttpService(httpUri, http.Client());
    return service!;
  });

  /// sync
  final syncRpc = XRPProvider(RPCHttpService(XRPProviderConst.devFaucetUrl, http.Client()));
  
  await rpc.request(RPCFee());
  await rpc.request(RPCServerInfo());
  await rpc.request(RPCAccountInfo(account: "..."));
  await rpc.request(RPCServerState());
  await rpc.request(RPCServerDefinitions());
  ...
```

- WEBSOCKET JSON RPC

```dart
  /// access devent
  final rpc = await XRPProvider.devNet((httpUri, websocketUri) async {
    service = await RPCWebSocketService.connect(websocketUri);
    return service!;
  });

  await rpc.request(RPCFee());
  await rpc.request(RPCServerInfo());
  await rpc.request(RPCAccountInfo(account: "..."));
  await rpc.request(RPCServerState());
  await rpc.request(RPCServerDefinitions());
  service?.discounnect();
  ...
```

- WEBSOCKET Subscribe

```dart
  /// stream event
  void onEnvet(Map<String, dynamic> event) {}

  void onClose(Object? err) {}

  /// access devent
  final rpc = await XRPProvider.mainnet((httpUri, websocketUri) async {
    service = await RPCWebSocketService.connect(websocketUri,
        onClose: onClose, onEvents: onEnvet);
    return service!;
  });

  /// subscribe
  await rpc.request(RPCSubscribe(streams: [
    StreamParameter.ledger,
  ]));
  ...
```

- Tailor the RPC response to your specifications.

```dart
/// Create a class that inherits from XRPLedgerRequest and customize it for handling Account NFT Offers IDs. Here's an example:
class RPCAccountNftOffersIDs extends XRPLedgerRequest<List<String>> {
  RPCAccountNftOffersIDs({
    required this.account,
    this.limit,
    this.marker,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountNfts;

  final String account;
  final int? limit;

  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {"account": account, "limit": limit, "marker": marker};
  }

  /// Override the `onResponse` method to manage and handle the desired outcomes from the RPC result as per your requirements.
  @override
  List<String> onResonse(Map<String, dynamic> result) {
    final List<dynamic> nfts = result["account_nfts"];
    return nfts.map<String>((e) => e["nft_offer_index"]).toList();
  }
  }

  final syncRpc = XRPProvider(RPCHttpService(XRPProviderConst.devFaucetUrl, http.Client()));
  final List<String> nftOfferIds =
      await syncRpc.request(RPCAccountNftOffersIDs(account: "..."));

  ...
```

## Contributing

Contributions are welcome! Please follow these guidelines:

- Fork the repository and create a new branch.
- Make your changes and ensure tests pass.
- Submit a pull request with a detailed description of your changes.

## Feature requests and bugs

Please file feature requests and bugs in the issue tracker.
