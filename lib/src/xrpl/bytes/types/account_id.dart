// Copyright (c) 2021, XRP Ledger Foundation

// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
// INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
// FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
// LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
// OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

//   Note: This code has been adapted from its original Python version to Dart.
//  The 3-Clause BSD License

//   Copyright (c) 2023 Mohsen Haydari (MRTNETWORK)
//   All rights reserved.

//   Redistribution and use in source and binary forms, with or without
//   modification, are permitted provided that the following conditions are met:

//   1. Redistributions of source code must retain the above copyright notice, this
//      list of conditions, and the following disclaimer.
//   2. Redistributions in binary form must reproduce the above copyright notice, this
//      list of conditions, and the following disclaimer in the documentation and/or
//      other materials provided with the distribution.
//   3. Neither the name of the [organization] nor the names of its contributors may be
//      used to endorse or promote products derived from this software without
//      specific prior written permission.

//   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//   IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//   OF THE POSSIBILITY OF SUCH DAMAGE.
part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

/// Utility class for Account ID operations
class _AccountIdUils {
  static final RegExp _hex20Bytes = RegExp(r'[A-F0-9]{40}');

  /// Checks if the input string is a 20-byte hash in hexadecimal format
  static bool isHash160(String v) {
    return _hex20Bytes.hasMatch(v);
  }
}

/// Represents an XRP account ID
class AccountID extends Hash160 {
  @override
  factory AccountID.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? Hash160.lengthBytes;
    final bytes = parser.read(numBytes);
    return AccountID(buffer: bytes);
  }

  /// Constructor for AccountID
  AccountID({required List<int> buffer}) : super(buffer);

  @override
  factory AccountID.fromValue(dynamic value) {
    if (value == null || value is! String || value.isEmpty) {
      return AccountID(buffer: List.filled(Hash160.lengthBytes, 0));
    }

    /// Hex-encoded case
    if (_AccountIdUils.isHash160(value)) {
      return AccountID(buffer: BytesUtils.fromHexString(value));
    }
    try {
      final addrHash = XRPAddressUtils.decodeAddress(value);
      return AccountID(buffer: addrHash);
    } catch (e) {
      throw XRPLBinaryCodecException(
          'Invalid value to construct an AccountID: expected valid classic address '
          '${value.runtimeType}, received ${value.runtimeType}.');
    }
  }

  @override
  String toJson() {
    return XRPAddressUtils.hashToAddress(_buffer);
  }
}
