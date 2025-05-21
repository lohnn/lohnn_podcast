import 'dart:io';

// Function to read input, with basic validation
String _promptUser(String promptMessage) {
  String? input;
  while (input == null || input.trim().isEmpty) {
    stdout.write('$promptMessage: ');
    input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) {
      stdout.writeln('Input cannot be empty. Please try again.');
    }
  }
  return input.trim();
}

Future<void> main() async {
  stdout.writeln('------------------------------------');
  stdout.writeln('Podcast Index API Key Setup Script');
  stdout.writeln('------------------------------------');
  stdout.writeln();
  stdout.writeln('This script will help you set up the API keys needed to search for podcasts.');
  stdout.writeln('You need to obtain an API Key and Secret from Podcast Index.');
  stdout.writeln('Please visit https://api.podcastindex.org/signup to create an account and get your credentials.');
  stdout.writeln();
  stdout.writeln('You will now be prompted to enter your API Key and Secret.');
  stdout.writeln();

  final apiKey = _promptUser('Enter your Podcast Index API Key');
  final apiSecret = _promptUser('Enter your Podcast Index API Secret');

  const filePath = 'apps/podcast/lib/secrets.dart';
  // Escape backslashes and single quotes for the Dart string literal
  final escapedApiKey = apiKey.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
  final escapedApiSecret = apiSecret.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

  final fileContent = """
// ignore_for_file: lines_longer_than_80_chars

class Secrets {
  const Secrets._();

  static const String searchApiKey = '$escapedApiKey';
  static const String searchApiSecret = '$escapedApiSecret';
}
""";

  try {
    // Ensure the directory exists
    final directoryPath = Directory(filePath).parent.path;
    final dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
      stdout.writeln('Created directory: $directoryPath');
    }

    // Write the file
    final file = File(filePath);
    await file.writeAsString(fileContent);

    stdout.writeln();
    stdout.writeln('Successfully created and populated $filePath with your API keys.');
    stdout.writeln('------------------------------------');

  } catch (e) {
    stdout.writeln('An error occurred while writing the secrets file: $e');
  }
}
