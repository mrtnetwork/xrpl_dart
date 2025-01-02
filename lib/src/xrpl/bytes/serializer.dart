/*
Copyright (c) 2021, XRP Ledger Foundation

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  Note: This code has been adapted from its original Python version to Dart.
*/
/*
  The 3-Clause BSD License
  
  Copyright (c) 2023 Mohsen Haydari (MRTNETWORK)
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  1. Redistributions of source code must retain the above copyright notice, this
     list of conditions, and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this
     list of conditions, and the following disclaimer in the documentation and/or
     other materials provided with the distribution.
  3. Neither the name of the [organization] nor the names of its contributors may be
     used to endorse or promote products derived from this software without
     specific prior written permission.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
  OF THE POSSIBILITY OF SUCH DAMAGE.
*/
library;

import 'dart:convert';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/bytes/binery_serializer/binary_serializer.dart';
import 'package:xrpl_dart/src/xrpl/bytes/definations/definations.dart';
import 'package:xrpl_dart/src/xrpl/bytes/definations/field.dart';
import 'package:xrpl_dart/src/xrpl/bytes/binery_serializer/binary_parser.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
part 'types/account_id.dart';
part 'types/amount.dart';
part 'types/blob.dart';
part 'types/currency.dart';
part 'types/hash.dart';
part 'types/hash128.dart';
part 'types/hash160.dart';
part 'types/hash256.dart';
part 'types/issue.dart';
part 'types/path.dart';
part 'types/st_array.dart';
part 'types/st_object.dart';
part 'types/uint.dart';
part 'types/uint16.dart';
part 'types/uint32.dart';
part 'types/uint64.dart';
part 'types/uint8.dart';
part 'types/vector256.dart';
part 'types/xchain_bridge.dart';

/// An abstract class representing a serialized XRPL object.
abstract class SerializedType {
  final List<int> _buffer;

  /// Constructs a SerializedType object with an optional buffer.
  /// If buffer is not provided, an empty bytes is used.
  SerializedType(List<int> buffer)
      : _buffer = BytesUtils.toBytes(buffer, unmodifiable: true);

  /// Converts the serialized object to a bytes.
  List<int> toBytes() {
    return List<int>.from(_buffer);
  }

  /// Converts the serialized object to a JSON representation.
  dynamic toJson() {
    return toHex();
  }

  @override
  String toString() {
    return toHex();
  }

  /// Converts the serialized object to a hexadecimal string.
  String toHex() {
    return BytesUtils.toHexString(_buffer, lowerCase: false);
  }

  /// Returns the length of the serialized object in bytes.
  int get length {
    return _buffer.length;
  }
}
