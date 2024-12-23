// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  print("First let's set up your Google auth URL.");

  print(
    'Please go to https://console.cloud.google.com/apis/credentials and create a new OAuth 2.0 client ID for Apple (iOS).',
  );
  print(
    'Please enter the client id: (e.g. 123456789-asdf4321.apps.googleusercontent.com)',
  );

  final clientId = stdin.readLineSync();
  final reversedClientId = clientId!.split('.').reversed.join('.');

  print('Also create a server client ID for the same project.');
  print(
    'Please enter the server client id: (e.g. 123456789-asdf4321.apps.googleusercontent.com)',
  );
  final serverClientId = stdin.readLineSync();

  print("Now let's set up your Supabase backend.");
  print('Enter your Supabase url: (e.g. https://abc123.supabase.co)');
  final backendUrl = stdin.readLineSync();

  print('Enter your Supabase anon key: (e.g. abc123)');
  final supabaseAnonKey = stdin.readLineSync();

  File('macos/Runner/PodcastSecrets.plist').writeAsStringSync(
    secretsPlistContent(reversedClientId),
  );
  File('ios/Runner/PodcastSecrets.plist').writeAsStringSync(
    secretsPlistContent(reversedClientId),
  );

  File('lib/secrets.dart').writeAsStringSync(
    secretsContent(
      backendUrl: backendUrl!,
      supabaseAnonKey: supabaseAnonKey!,
      googleClientId: clientId,
      googleServerClientId: serverClientId!,
    ),
  );
  print('Config is now set up and ready to go!');
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
}) =>
    '''
class Secrets {
  const Secrets._();

  static const String supabaseUrl = '$backendUrl';
  static const String supabaseAnonKey = '$supabaseAnonKey';
  static const String googleClientId = '$googleClientId';
  static const String googleServerClientId = '$googleServerClientId';
}
''';
