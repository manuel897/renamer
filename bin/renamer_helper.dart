class RenamerHelper {
  static final RenamerHelper _instance = RenamerHelper._internal();

  /// private constructor for creating an instance
  RenamerHelper._internal();

  factory RenamerHelper() {
    return _instance;
  }

  /// transform a strings to a known pattern
  String transformString(String inputString, NamingPattern namingPattern) {
    var result = "";
    var parts = _splitString(inputString);

    if (namingPattern == NamingPattern.upperCamelCase) {
      for (var part in parts) {
        part = part.toLowerCase();
        result = result +
            part[0].toUpperCase() +
            part.substring(
              1,
            );
      }
    }
    return result.isEmpty ? inputString : result;
  }

  /// split a string if it is separated by space, - or _
  List<String> _splitString(String inputString) {
    final List<String> result = [];
    String? splitter;
    if (inputString.contains(" ")) {
      splitter = " ";
    } else if (inputString.contains("_")) {
      splitter = " ";
    } else if (inputString.contains("-")) {
      splitter = " ";
    }
    if (splitter != null) {
      var splitStrings = inputString.trim().split(splitter);
      splitStrings.removeWhere((e) => e.isEmpty);
      result.addAll(splitStrings);
    }
    return result;
  }

  /// extracts name (including extension) from a path
  String? getNameWithExtension(String path) {
    return path.split('/').lastOrNull;
  }
}

enum NamingPattern {
  upperCamelCase,
  upperSnakeCase;
}
