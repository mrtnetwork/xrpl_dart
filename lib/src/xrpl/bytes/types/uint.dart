part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

abstract class UInt extends SerializedType {
  UInt(super.buffer);

  int get value {
    return IntUtils.fromBytes(_buffer);
  }

  @override
  dynamic toJson() {
    return value;
  }
}
