# XRP Dart Package

This package provides functionality to sign XRP transactions using two popular cryptographic algorithms, 
ED25519 and SECP256K1. It allows developers to create and sign XRP transactions securely.

## Features

### Transaction Types
The XRP Ledger supports various transaction types, each serving a different purpose:

- Payment Transactions: Standard transactions used to send XRP or Issue from one address to another.
- Escrow Transactions: These transactions lock up XRP until certain conditions are met, providing a trustless way to facilitate delayed payments.
- TrustSet Transactions: Used to create or modify trust lines, enabling users to hold and trade assets other than XRP on the ledger.
- OrderBook Transactions: Used to place and cancel offers on the decentralized exchange within the XRP Ledger.
- PaymentChannel Transactions: Allow for off-chain payments using payment channels.
- NFT: Mint NFTs, cancel them, create offers, and seamlessly accept NFT offers
- Issue: Issue custom assets
- Automated Market Maker: operations like bidding, creation, deletion, deposits, voting
- RegularKey: transactions to set or update account regular keys
- Offer: creation, cancel
- multi-signature transaction

### Addresses
- classAddress: They are straightforward representations of the recipient's address on the XRP Ledger
- xAddress: newer format, which provides additional features and interoperability. xAddresses include destination tags by default and are designed to simplify cross-network transactions and improve address interoperability

### Sign
- Sign XRP transactions with ED25519 and SECP256K1 algorithms.

### BIP-39
- Generate BIP39 mnemonics, providing a secure and standardized way to manage keys and seed phrases

### HD Wallet
- Implement hierarchical deterministic (HD) wallet derivation

### Web3 Secret Storage Definition
- JSON Format: Private keys are stored in a JSON (JavaScript Object Notation) format, making it easy to work with in various programming languages.
- Encryption: The private key is encrypted using the user's chosen password. This ensures that even if the JSON file is compromised, an attacker cannot access the private key without the password.
- Key Derivation: The user's password is typically used to derive an encryption key using a key derivation function (KDF). This derived key is then used to encrypt the private key.
- Scrypt Algorithm: The Scrypt algorithm is commonly used for key derivation, as it is computationally intensive and resistant to brute-force attacks.
- Checksum: A checksum is often included in the JSON file to help detect errors in the password.
- Initialization Vector (IV): An IV is typically used to add an extra layer of security to the encryption process.
- Versioning: The JSON file may include a version field to indicate which version of the encryption and storage format is being used.
- Metadata: Additional metadata, such as the address associated with the private key, may be included in the JSON file.

### JSON-RPC Support
communicate with XRP nodes via the JSON-RPC protocol
It has been attempted to embed all the methods into RPC; however, currently, most of the data APIs are delivered in JSON format, and they have not been modeled.

## EXAMPLES
At least one example has been created for each transaction type, which you can find in the 'examples' folder.

### Key and addresses
```
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
Each type of transaction has its own class for creating transactions
Descriptions for some of these classes are provided below.

- Simple payment
  
  ```
    final transaction = Payment(
      destination: destination, // destination account
      account: ownerAddress, // Sender account
      amount: amount, // The amount sent can be in XRP or any other token.
      signingPubKey: ownerPublic); // Sender's public key

  ```
- NTF, mint, createOffer, acceptOffer
   
  ```
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
  ```
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

### BIP39
```
  final mnemonic = BIP39.generateMnemonic();
  /// document nation mushroom rate size rich promote screen rocket winter turtle
  final seed = BIP39.toSeed(mnemonic, passphrase: "MRTNETWORK");
  ...
```
### HD Wallet
```
  final mnemonic = BIP39.generateMnemonic();
  const String defaultXRPSecp256k1Path = "m/44'/144'/0'/0/0";
  final masterWallet =
      HdWallet.fromMnemonic(mnemonic, passphrase: 'MRTNETWORK');
  masterWallet.private;
  final deriveWallet =
      HdWallet.drivePath(masterWallet, defaultXRPSecp256k1Path);
  /// accsess to private key `deriveWallet.private`
 ...
```
### Web3 Secret Storage Definition
```
  final String password = "....";
  final String data = "....";
  final createSecret =
      SecretWallet.encode(bytesToHex(utf8.encode(data)), password);

   ///{"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"5031fb84417a51970c7da9116dbd5a78"}, ...

  final decodeSecret = SecretWallet.decode(createSecret.toJson(), password);
```
### JSON-RPC
```
  /// access devent
  final devnetRPC = XRPLRpc.devNet();

  /// access testnet
  final testnetRPC = XRPLRpc.testNet();

  /// access mainnet
  final mainnetRPC = XRPLRpc.testNet();

  /// access amm-Devnet
  final ammDevnetRPC = XRPLRpc.ammDevnet();
  
  final customURL = XRPLRpc(JsonRPC("https://....", http.Client()));
  await devnetRPC.getFucent(address);

  await devnetRPC.getAccountTX(address);

  await devnetRPC.getFee();

  ...
```

## Contributing

Contributions are welcome! Please follow these guidelines:
 - Fork the repository and create a new branch.
 - Make your changes and ensure tests pass.
 - Submit a pull request with a detailed description of your changes.

## Feature requests and bugs #

Please file feature requests and bugs in the issue tracker.


