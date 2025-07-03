class BinaryParserUtils {
  static final RegExp hex20Bytes = RegExp(r'[A-F0-9]{40}');
  static bool is20BytesHex(String v) {
    return hex20Bytes.hasMatch(v);
  }
}
