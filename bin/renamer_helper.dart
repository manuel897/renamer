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

    final String separator = namingPatternSeparator[namingPattern] ?? "";
    parts = _addSeparatorInString(parts, separator);
    for (var part in parts) {
      part = part.toLowerCase();
      result = result + _capitaliseFirstLetter(part);
    }

    return result.isEmpty ? inputString : result;
  }

  /// add a separator between given strings
  List<String> _addSeparatorInString(List<String> inputList, String separator) {
    final List<String> result = [];
    for (int i = 0; i < inputList.length; i++) {
      result.add(inputList[i]);
      if (i != inputList.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  String _capitaliseFirstLetter(String input) => input.isNotEmpty
      ? input[0].toUpperCase() +
          input.substring(
            1,
          )
      : "";

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
  upperSnakeCase,
  upperKebabCase;
}

const Map<NamingPattern, String> namingPatternSeparator = {
  NamingPattern.upperCamelCase: "",
  NamingPattern.upperSnakeCase: "_",
  NamingPattern.upperKebabCase: "-",
};
