# XRPL Dart Package

Dart library for the XRP Ledger: build, sign, and submit transactions (Ed25519 + secp256k1), manage accounts, trust lines, DEX offers, NFTs, AMMs, credentials, vaults, and multi-purpose tokens — with JSON-RPC, WebSocket, and a one-call quick client.

This package is the continuation of the original
[mrtnetwork/xrpl_dart](https://github.com/mrtnetwork/xrpl_dart).

## Crypto engine: `blockchain_utils` dual backend

All cryptography (Ed25519, secp256k1, hashing) delegates to
[`blockchain_utils`](https://github.com/mrtnetwork/blockchain_utils): pure
Dart by default, optional Rust backend (FFI on native, WASM on web). When set
(`blockchainUtils.setRustApi()`), all high-level crypto used here routes
through Rust. Rust core:
[mrtnetwork/blockchain-utils](https://github.com/mrtnetwork/blockchain-utils).

## Supported networks

| Network | Support |
|---|---|
| Mainnet | ✅ |
| Testnet | ✅ |
| Devnet | ✅ (+ custom / sidechain via explicit URLs) |

## Features

### Transactions

| Group | Operations |
|---|---|
| Payments | Payment (incl. `domain_id`, `credential_ids`), escrow create/finish/cancel |
| Trust | TrustSet (incl. DeepFreeze flags), trust lines |
| DEX | OfferCreate (incl. `domain_id`, `tfHybrid`) / cancel, order-book flows |
| Channels | Payment-channel create / fund / claim / close |
| NFTs | Mint (incl. `tfMutable` DynamicNFT), burn, offers, accept, `NFTokenModify` |
| AMM | Create / deposit / withdraw / vote / bid, delete |
| Accounts | Set options, regular keys, account delete, ticket create |
| Credentials | Create / accept / delete (+ `credential_ids` on payments, escrow, channels) |
| MPT | Multi-purpose token issuance (create / set / destroy), authorize, holders |
| Vaults | Vault create / modify, asset operations |
| Cross-chain | XChain bridge create, account/claim commits and attestations |
| Multisig | Multi-signature transactions, `sign_for` flows |

### Addresses & keys

| Area | Support |
|---|---|
| Classic | Base58 addresses, ED25519 / secp256k1 keypairs, BIP-32/39 HD |
| X-Address | Tag-packing format, `IAddress` integration (`XRPBaseAddress`) |
| Signing | Local sign, auto-fill (fee, sequence, last-ledger), submit + status poll |

### Providers

| API | Support |
|---|---|
| JSON-RPC | Full method set incl. `feature`, `sign`, `sign_for`, `vault_info`, `nfts_by_issuer`, MPT holders/issuances |
| WebSocket | Subscribe streams, real-time feeds |
| Quick client | `XRPQuickClientApi` — one method per top call (balance, fee, fill + simulate, sign, submit, poll, NFTs/offers/lines/objects, ledger reads) |

Definitions are drift-checked against live `server_definitions`
(`NFTokenModify`, `Vault`, `CredentialIDs`, `DomainID`, `NFTokenID`) via
`tool/live_quick_test.dart` across mainnet, testnet, and devnet.

## Examples

Explore at least one example per transaction type in
[`example/`](https://github.com/mrtnetwork/xrpl_dart/tree/main/example).

## Testing

```sh
dart test            # unit + backend-parity suites
```

Backend-parity one-shot suites (`one_shot_suite.dart`, `test_backend.dart`)
exercise both the pure-Dart and Rust/WASM backends. Live checks:

```sh
dart tool/live_quick_test.dart
```

## Contributing

Contributions are welcome! Please follow these guidelines:

- Fork the repository and create a new branch.
- Make your changes and ensure tests pass.
- Submit a pull request with a detailed description of your changes.

## Feature requests and bugs

Please file feature requests and bugs in the issue tracker.
