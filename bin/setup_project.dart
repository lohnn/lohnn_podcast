import 'dart:io';

// Function to read input, with basic validation
String _promptUser(String promptMessage) {
  String? input;
  while (input == null || input.trim().isEmpty) {
    stdout.write('$promptMessage: ');
    input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) {
      print('Input cannot be empty. Please try again.');
    }
  }
  return input.trim();
}

Future<void> main() async {
  print('------------------------------------');
  print('Podcast Index API Key Setup Script');
  print('------------------------------------');
  print('');
  print('This script will help you set up the API keys needed to search for podcasts.');
  print('You need to obtain an API Key and Secret from Podcast Index.');
  print('Please visit https://podcastindex.org/developers/signup to create an account and get your credentials.');
  print('');
  print('You will now be prompted to enter your API Key and Secret.');
  print('');

  final apiKey = _promptUser('Enter your Podcast Index API Key');
  final apiSecret = _promptUser('Enter your Podcast Index API Secret');

  final filePath = 'apps/podcast/lib/secrets.dart';
  // Escape backslashes and single quotes for the Dart string literal
  final escapedApiKey = apiKey.replaceAll(r'\', r'\\').replaceAll(r"'", r"\'");
  final escapedApiSecret = apiSecret.replaceAll(r'\', r'\\').replaceAll(r"'", r"\'");

  final fileContent = '''// ignore_for_file: lines_longer_than_80_chars

class Secrets {
  const Secrets._();

  static const String searchApiKey = \'$escapedApiKey\';
  static const String searchApiSecret = \'$escapedApiSecret\';
}
''';

  try {
    // Ensure the directory exists
    final directoryPath = Directory(filePath).parent.path;
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print('Created directory: $directoryPath');
    }

    // Write the file
    final file = File(filePath);
    await file.writeAsString(fileContent);

    print('');
    print('Successfully created and populated $filePath with your API keys.');
    print('------------------------------------');

  } catch (e) {
    print('An error occurred while writing the secrets file: $e');
  }
}
