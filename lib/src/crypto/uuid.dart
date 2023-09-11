library uuid;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

class UUID {
  static String generateUUIDv4() {
    final random = math.Random.secure();

    final bytes = List<int>.generate(16, (i) {
      if (i == 6) {
        return (random.nextInt(16) & 0x0f) | 0x40;
      } else if (i == 8) {
        return (random.nextInt(4) & 0x03) | 0x08;
      } else {
        return random.nextInt(256);
      }
    });

    bytes[10] = (bytes[10] & 0x3f) | 0x80; // Set the 6th high-order bit.

    final List<String> hexBytes =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).toList();

    return '${hexBytes.sublist(0, 4).join('')}-${hexBytes.sublist(4, 6).join('')}-${hexBytes.sublist(6, 8).join('')}-${hexBytes.sublist(8, 10).join('')}-${hexBytes.sublist(10).join('')}';
  }

  static Uint8List toBuffer(String uuidString) {
    final buffer = Uint8List(16);

    // Remove dashes and convert the hexadecimal string to bytes
    final cleanUuidString = uuidString.replaceAll('-', '');
    final bytes = hexToBytes(cleanUuidString);

    // Copy the bytes into the buffer
    for (var i = 0; i < 16; i++) {
      buffer[i] = bytes[i];
    }

    return buffer;
  }

  static String fromBuffer(Uint8List buffer) {
    if (buffer.length != 16) {
      throw Exception(
          'Invalid buffer length. UUIDv4 buffers must be 16 bytes long.');
    }

    final List<String> hexBytes =
        buffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).toList();

    // Insert dashes at appropriate positions to form a UUIDv4 string
    return '${hexBytes.sublist(0, 4).join('')}-${hexBytes.sublist(4, 6).join('')}-${hexBytes.sublist(6, 8).join('')}-${hexBytes.sublist(8, 10).join('')}-${hexBytes.sublist(10).join('')}';
  }
}
