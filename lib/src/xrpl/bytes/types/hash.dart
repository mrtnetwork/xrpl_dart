part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

abstract class Hash extends SerializedType {
  Hash(Uint8List buffer) : super(buffer);

  int getLength() => throw UnimplementedError();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hash &&
        runtimeType == other.runtimeType &&
        listEquals(buffer, other.buffer);
  }

  @override
  int get hashCode => buffer.hashCode;
}
