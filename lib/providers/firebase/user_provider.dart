import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcast/providers/firebase/firebase_app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPod extends _$UserPod {
  late FirebaseAuth _auth;
  final _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> build() async* {
    final app = await ref.watch(firebaseAppProvider.future);
    _auth = FirebaseAuth.instanceFor(app: app);

    if (kIsWeb) {
      _auth.setPersistence(Persistence.LOCAL);
    }

    yield _auth.currentUser;
    yield* _auth.userChanges();
  }

  Future<void> logIn() async {
    final googleAuth = await switch (
        await _googleSignIn.signInSilently(reAuthenticate: true)) {
      final user? => user.authentication,
      _ => (await _googleSignIn.signIn())?.authentication,
    };

    if (googleAuth == null) return;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _auth.signInWithCredential(credential);
    return;
  }

  void logOut() => _auth.signOut();
}
