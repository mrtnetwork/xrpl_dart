## 8.0.0
- BREAKING: all legacy exception classes removed; every error is now `BuError` with an `XrplErrorType` taxonomy value.
- Cryptography now routes through the `blockchain_utils` dual backend (pure Dart default, optional Rust FFI/WASM) with backend-parity test suites.
- `server_definitions` drift check now covers `NFTokenModify`, `Vault`, `CredentialIDs`, `DomainID`, `NFTokenID`.

## 7.8.0

- Added `XRPQuickClientApi` / `DefaultXRPQuickClient` (`lib/src/rpc/quick/`): one method per top wallet/swap call (account info/balance/sequence, fee, fill + fee + simulate pipeline, local sign, submit, tx status/poll, account tx/NFTs/offers/lines/objects, ledger reads) — no wallet-store specifics (streams, xrplmeta, genesis checks).
- Fixed `XRPRequestLedgerCurrent` to accept both `ledger_current_index` and `ledger_index` (int or numeric string); throws `BuError` when both are missing.
- Added `tool/live_quick_test.dart`: read-only live checks across mainnet, testnet and devnet, including a `server_definitions` drift check (live table must contain `NFTokenModify`, `Vault`, `CredentialIDs`, `DomainID`, `NFTokenID`).

## 7.7.0


- Added NFTokenModify transaction (DynamicNFT amendment, live on mainnet since 2025-06-11) and the `tfMutable` NFTokenMint flag.
- TrustSet: added `tfSetDeepFreeze` / `tfClearDeepFreeze` flags (DeepFreeze amendment).
- OfferCreate: added `domain_id` field and `tfHybrid` flag (PermissionedDEX amendment).
- Payment: added `domain_id` and `credential_ids` fields (PermissionedDEX / Credentials amendments).
- EscrowFinish, PaymentChannelClaim, AccountDelete: added `credential_ids` field (Credentials amendment).
- Added RPC methods: `feature`, `sign`, `sign_for`, `vault_info`, `nfts_by_issuer`, `account_mptokens`, `account_mptoken_issuances`, `mpt_holders`.
- Fixed `XRPPrivateKey.fromEntropy` ignoring the `algorithm` parameter (always derived ed25519).

## 7.6.0

- Fix parsing NFTokenAcceptOffer

## 7.5.0

- Updated dependencies.
- Renamed XRPLAddress to XRPBaseAddress.
- Updated XRPXAddress to inherit from IAddress provided by blockchain_utils.

## 7.4.0

- Update dependencies.
- Minimum required Dart SDK version updated to 3.7.


## 7.3.0

- Update dependencies.

## 7.2.0

- Fix parsing RPC error

## 7.1.0

- Update dependencies.

## 7.0.0

- Refactored RPC API method responses into models
- Added support for: batch, credential, mptoken, and delegate
- Added unit tests for each transaction model
Note: Many API methods have changed. Please refer to the updated examples before upgrading the package.


## 6.0.0

- Fix parsing RPC error

## 5.9.0

- Update dependencies.

## 5.8.0

- Fix parsing RPC error

## 5.7.0

- Update dependencies.

## 5.6.0

- Update dependencies.

## 5.4.0

- Update dependencies.

## 5.3.0

- Update dependencies.

## 5.2.0

- Update dependencies.

## 5.1.0

- Update dependencies.

## 5.0.0

- Minimum required Dart SDK version updated to 3.3.
- The RPC method names and service class implementations have been updated. Please refer to the examples folder for guidance.
- Update dependencies.

## 4.9.0

- Fix parsing RPC Error.
- Important Notice: This is the final version supporting Dart v2. The next release will require Dart v3.3 or higher.

## 4.8.0

- Update dependencies.

## 4.7.0

- Update dependencies.

## 4.6.0

- Fix parsing of XRPLedgerState model when using WebSocket service.

## 4.5.0

- Update dependencies.

## 4.4.0

- Update dependencies.

## 4.3.0

- Update dependencies.

## 4.2.0

- Update dependencies.
- Some API changed please review the examples.

## 4.1.2

- Update dependencies.

## 4.1.1

- Update dependencies.

## 4.1.0

- Update dependencies.

## 4.0.1

- Update the README.

## 4.0.0

- Changed the package name from xrp_dart to xrpl_dart to match the already existing SDK naming convention

## 3.0.3

- Corrected fee calculation in the autoFill method.
- Updated dependencies for enhanced performance and security.

## 3.0.2

- Update dependencies.
- Fixed encodeSeed method in web.

## 3.0.1

- Update dependencies.

## 3.0.0

- Added support for JSON-RPC WebSocket, expanding communication options.
- Downgraded Dart SDK from 3.1 to 2.15 for compatibility.
- Introduced support for new transaction types:
  - XChainAccountCreateCommit
  - XChainAddAccountCreateAttestation
  - XChainAddClaimAttestation
  - XChainClaim
  - XChainCreateBridge
  - XChainModifyBridge

## 2.0.0

- Remove unused dependencies.
- Update dependencies.
- Fix Some method for web.

## 1.1.0

- Update dependencies.

## 0.2.0

- Removing inefficient methods.

## 0.1.0

- TODO: Release.
