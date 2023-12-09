part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

abstract class Hash extends SerializedType {
  Hash(List<int> super.buffer);

  int getLength() => throw UnimplementedError();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hash &&
        runtimeType == other.runtimeType &&
        bytesEqual(_buffer, other._buffer);
  }

  @override
  int get hashCode => _buffer.hashCode;
}
