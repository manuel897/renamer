class RenamerHelper {
  static final RenamerHelper _instance = RenamerHelper._internal();

  /// private constructor for creating an instance
  RenamerHelper._internal();

  factory RenamerHelper() {
    return _instance;
  }

  /// transform a strings to a known pattern
  String transformString(String string, NamingPattern namingPattern) {
    return "Not implemented";
  }

  /// extracts name (including extension) from a path
  String? getNameWithExtension(String path) {
    return path.split('/').lastOrNull;
  }
}

enum NamingPattern {
  upperCamelCase;
}
