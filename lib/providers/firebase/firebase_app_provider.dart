import 'package:firebase_core/firebase_core.dart';
import 'package:podcast/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_app_provider.g.dart';

@Riverpod(keepAlive: true)
Future<FirebaseApp> firebaseApp(FirebaseAppRef ref) {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
