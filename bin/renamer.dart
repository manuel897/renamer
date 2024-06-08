import 'dart:io';

import 'package:args/args.dart';

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
  print('Usage: dart renamer.dart <path> <ignore item 1> <ignore item 2> ...');
  print(argParser.usage);
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
      print('renamer version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    // print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    if (results.arguments.isEmpty) {
      throw FormatException(
          '1 positional argument is expected. ${results.arguments.length} found.');
    }

    var entryPath = results.arguments.first;

    try {
      final entryDir = Directory(entryPath);
      if (!entryDir.existsSync()) {
        print('Specified path $entryPath does not exist.');
        return;
      }
      var itemList = entryDir.listSync();

      final ignoreList = results.arguments.sublist(1);
      print("Ignoring: $ignoreList");
      for (final item in ignoreList) {
        itemList.removeWhere((e) => e.path.contains(item));
      }
      for (final FileSystemEntity item in itemList) {
        if (item is File) {
          print("${item.path} is a file");
        } else if (item is Directory) {
          print("${item.path} is a directory");
        } else {
          print("${item.path} is something else");
        }
      }
    } on PathAccessException catch (e) {
      print('Path $entryPath is inaccessible.');
      print(e);
    } catch (e) {
      if (e == PathAccessException) {
        print('Path $entryPath is inaccessible.');
      }
    }

    // var systemTempDir = Directory.systemTemp;
    // systemTempDir
    //     .list(recursive: true, followLinks: false)
    //     .listen((FileSystemEntity e) {
    //   print(e.path);
    // });
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
