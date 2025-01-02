part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

abstract class Hash extends SerializedType {
  Hash(super.buffer) {
    if (_buffer.length != getLength()) {
      throw XRPLBinaryCodecException(
          'Invalid hash length ${_buffer.length}. ${getLength()}');
    }
  }

  int getLength();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hash &&
        runtimeType == other.runtimeType &&
        BytesUtils.bytesEqual(_buffer, other._buffer);
  }

  @override
  int get hashCode => _buffer.hashCode;
}
