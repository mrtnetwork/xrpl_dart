import 'dart:convert';
import 'dart:typed_data';

import 'package:typed_data/typed_buffers.dart';

/// A utility class for tracking bytes dynamically and converting them to a Uint8List.
class DynamicByteTracker extends ByteConversionSinkBase {
  final Uint8Buffer _buffer = Uint8Buffer();
  int _length = 0;

  /// Get the current length of the tracked bytes.
  int get length => _length;

  /// Get the last byte in the tracked bytes.
  int get last => _buffer.last;

  /// Convert the tracked bytes to a Uint8List.
  Uint8List toBytes() {
    return _buffer.buffer.asUint8List(0, _length);
  }

  @override
  void add(List<int> chunk) {
    _buffer.addAll(chunk);
    _length += chunk.length;
  }

  @override
  void close() {}
}
