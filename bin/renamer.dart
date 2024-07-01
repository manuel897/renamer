import 'dart:io';

import 'package:args/args.dart';

import 'renamer_helper.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  stdout.writeln(
      'Usage: dart renamer.dart <path> <ignore item 1> <ignore item 2> ...');
  stdout.writeln(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      stdout.writeln('renamer version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    if (verbose) {
      stdout.writeln('[VERBOSE] All arguments: ${results.arguments}');
    }

    if (results.arguments.isEmpty) {
      throw FormatException(
          '1 positional argument is expected. ${results.arguments.length} found.');
    }

    final String entryPath = results.arguments.first;

    try {
      final Directory entryDir = Directory(entryPath);
      if (!entryDir.existsSync()) {
        stdout.writeln('Specified path $entryPath does not exist.');
        return;
      }

      final List<FileSystemEntity> itemList = entryDir.listSync();

      final List<String> ignoreList = results.arguments.sublist(1);
      stdout.writeln("Ignoring: $ignoreList");

      for (final String item in ignoreList) {
        itemList.removeWhere((e) => e.path.contains(item));
      }

      stdout.writeln("Please specify a naming pattern:");
      stdout.writeln("1 = upper camel case (JaneDoe) [default]");
      stdout.writeln("2 = upper snake case (Jane_Doe)");
      stdout.writeln("3 = upper kebab case (Jane-Doe)");
      final String? input = stdin.readLineSync();
      NamingPattern namingPattern = NamingPattern.upperCamelCase;
      switch (input) {
        case "1":
          stdout.writeln('Selected upper camel case');
          break;
        case "2":
          stdout.writeln('Selected upper snake case');
          namingPattern = NamingPattern.upperSnakeCase;
        case "3":
          stdout.writeln('Selected upper kebab case');
          namingPattern = NamingPattern.upperKebabCase;
        default:
          stdout.writeln('Selected upper camel case');
          break;
      }

      for (final FileSystemEntity item in itemList) {
        final name = RenamerHelper().getNameWithExtension(item.path);

        if (name != null) {
          stdout.writeln(
              "$name -> ${RenamerHelper().transformString(name, namingPattern)}");
        }
      }
    } on PathAccessException catch (e) {
      stderr.writeln('Path $entryPath is inaccessible.');
      stderr.writeln(e);
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    stderr.writeln(e.message);
    stderr.writeln('');
    printUsage(argParser);
  }
}
