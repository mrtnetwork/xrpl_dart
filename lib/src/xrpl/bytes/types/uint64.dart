part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt64 extends UInt {
  static const int lengthInBytes = 8;
  static RegExp get radix10 => RegExp(r'^\d{1,20}$');
  static const List<String> specialTypeNames = [
    "MaximumAmount",
    "OutstandingAmount",
    "MPTAmount",
  ];

  UInt64([List<int>? buffer])
    : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  factory UInt64.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt64(parser.read(lengthInBytes));
  }

  factory UInt64.fromValue(dynamic value, {String? typeName}) {
    if (value is! String && value is! int && value is! BigInt) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Invalid type to construct a UInt64: expected String, int or BigInt, received ${value.runtimeType}.',
      );
    }
    if (value is int) {
      if (value.isNegative) {
        throw BuError(DefaultErrorType.invalidArgument, '$value must be an unsigned integer');
      }
      return UInt64(value.toBeBytes(length: lengthInBytes));
    }
    if (value is BigInt) {
      if (value.isNegative) {
        throw BuError(DefaultErrorType.invalidArgument, '$value must be an unsigned integer');
      }
      return UInt64(value.toBeBytes(length: lengthInBytes));
    } else if (value is String) {
      if (radix10.hasMatch(value)) {
        return UInt64(
          BigintUtils.parse(value).toBeBytes(length: lengthInBytes),
        );
      }
      if (StringUtils.isHexBytes(value, lengthInBytes: lengthInBytes)) {
        try {
          return UInt64(BytesUtils.fromHexString(value));
        } catch (_) {
          throw BuError(DefaultErrorType.invalidArgument, 'Invalid UInt64 hex value $value.');
        }
      }
    }
    throw BuError(DefaultErrorType.invalidArgument, 
      'Invalid UInt64 value $value: expected up to 20 decimal digits or up to 16 hex characters.',
    );
  }

  @override
  String toJson() {
    return BytesUtils.toHexString(_buffer, prefix: "0x");
  }
}
