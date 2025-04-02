import 'dart:convert';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

// @TODO: Add to startup script: google-services.json

void main(List<String> args) {
  if (args.contains('--help')) {
    stdout.writeln('''
    This script sets up the project with the necessary secrets.
    
    You can either provide a file with the secrets or enter them manually in 
    a flow (no arguments).
    
    Usage with file:
    [no arguments]  Read secrets from input one by one
    -f <file>       Read secrets from a file
    ''');
    return;
  }

  final Keys keys;
  if (args.indexOf('-f') case final fileIndex
      when fileIndex != -1 && args.length > fileIndex + 1) {
    keys = Keys.readFromFile(args[fileIndex + 1]);
  } else {
    keys = Keys.collectFromInput();
  }

  final reversedClientId = keys.clientId.split('.').reversed.join('.');
  File(
    'apps/podcast/macos/Runner/PodcastSecrets.plist',
  ).writeAsStringSync(secretsPlistContent(reversedClientId));
  File(
    'apps/podcast/ios/Runner/PodcastSecrets.plist',
  ).writeAsStringSync(secretsPlistContent(reversedClientId));

  File('apps/podcast/lib/secrets.dart').writeAsStringSync(
    secretsContent(
      backendUrl: keys.backendUrl,
      supabaseAnonKey: keys.supabaseAnonKey,
      googleClientId: keys.clientId,
      googleServerClientId: keys.serverClientId,
    ),
  );
  stdout.writeln('Config is now set up and ready to go!');
}

String secretsPlistContent(String reversedClientId) => '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$reversedClientId</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Viewer</string>
			<key>CFBundleURLName</key>
			<string>se.lohnn.podcast</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>lohnnpodcast</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
''';

String secretsContent({
  required String backendUrl,
  required String supabaseAnonKey,
  required String googleClientId,
  required String googleServerClientId,
}) => '''
class Secrets {
  const Secrets._();

  static const String supabaseUrl = '$backendUrl';
  static const String supabaseAnonKey = '$supabaseAnonKey';
  static const String googleClientId = '$googleClientId';
  static const String googleServerClientId = '$googleServerClientId';
}
''';

class Keys {
  final String clientId;
  final String serverClientId;
  final String backendUrl;
  final String supabaseAnonKey;

  const Keys({
    required this.clientId,
    required this.serverClientId,
    required this.backendUrl,
    required this.supabaseAnonKey,
  });

  factory Keys.collectFromInput() {
    final files = Glob(
      'project_setup_config*.json',
    ).listSync().whereType<File>().toList(growable: false);

    if (files.isNotEmpty) {
      stdout.writeln(
        'You seem to have config file(s) already. Do you want to use it?',
      );
      stdout.writeln('Files:');
      stdout.writeln('0 - Enter config manually');
      for (final (index, file) in files.indexed) {
        stdout.writeln('${index + 1} - ${file.path}');
      }
      stdout.write('Enter the index of the file you want to use: ');

      final fileIndex = int.tryParse(stdin.readLineSync()!) ?? 0;
      if (fileIndex != 0) {
        stdout.writeln();
        stdout.writeln('Using file: ${files[fileIndex - 1].path}');
        return Keys.readFromFile(files[fileIndex - 1].path);
      }
    }

    stdout.writeln("First let's set up your Google auth URL.");

    stdout.writeln(
      'Please go to https://console.cloud.google.com/apis/credentials and create a new OAuth 2.0 client ID for Apple (iOS).',
    );
    stdout.writeln(
      'Please enter the client id: (e.g. 123456789-asdf4321.apps.googleusercontent.com)',
    );

    final clientId = stdin.readLineSync();

    stdout.writeln('Also create a server client ID for the same project.');
    stdout.writeln(
      'Please enter the server client id: (e.g. 123456789-asdf4321.apps.googleusercontent.com)',
    );
    final serverClientId = stdin.readLineSync();

    stdout.writeln("Now let's set up your Supabase backend.");
    stdout.writeln(
      'Enter your Supabase url: (e.g. https://abc123.supabase.co)',
    );
    final backendUrl = stdin.readLineSync();

    stdout.writeln('Enter your Supabase anon key: (e.g. abc123)');
    final supabaseAnonKey = stdin.readLineSync();

    return Keys(
      clientId: clientId!,
      serverClientId: serverClientId!,
      backendUrl: backendUrl!,
      supabaseAnonKey: supabaseAnonKey!,
    );
  }

  factory Keys.readFromFile(String filePath) {
    final content = File(filePath).readAsStringSync();

    final {
      'clientId': String clientId,
      'serverClientId': String serverClientId,
      'backendUrl': String backendUrl,
      'supabaseAnonKey': String supabaseAnonKey,
    } = (json.decode(content) as Map);

    return Keys(
      clientId: clientId,
      serverClientId: serverClientId,
      backendUrl: backendUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
  }

  @override
  String toString() {
    return 'Keys('
        'clientId: $clientId, '
        'serverClientId: $serverClientId, '
        'backendUrl: $backendUrl, '
        'supabaseAnonKey: $supabaseAnonKey'
        ')';
  }
}
