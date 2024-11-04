import 'package:firebase_auth/firebase_auth.dart' hide OAuthProvider, User;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_provider.g.dart';

@riverpod
class UserPod extends _$UserPod {
  late FirebaseAuth _firebaseAuth;
  late GoTrueClient _supabaseAuth;

  // final _googleSignIn = GoogleSignIn();
  final _supabaseGoogleSignIn = GoogleSignIn(
    clientId:
        const String.fromEnvironment('CLIENT_ID'),
    serverClientId:
        const String.fromEnvironment('SERVER_CLIENT_ID'),
  );

  @override
  Stream<User?> build() async* {
    _firebaseAuth = FirebaseAuth.instance;
    _supabaseAuth = Supabase.instance.client.auth;

    if (kIsWeb) {
      _firebaseAuth.setPersistence(Persistence.LOCAL);
    }

    await for (final _ in _supabaseAuth.onAuthStateChange) {
      yield _supabaseAuth.currentUser;
    }
  }

  Future<void> logIn() async {
    // TODO(lohnn): Figure out how to get this working
    // await _supabaseAuth.signInWithOAuth(
    //   OAuthProvider.google,
    //   redirectTo: 'lohnnpodcast://se.lohnn.poodcast/authenticated',
    // );
    // print('hello');
    // return;

    await _firebaseAuth.signInAnonymously();

    // Supabase
    final supabaseAuth = await switch (
        await _supabaseGoogleSignIn.signInSilently(reAuthenticate: true)) {
      final user? => user.authentication,
      _ => (await _supabaseGoogleSignIn.signIn())?.authentication,
    };
    await _supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: supabaseAuth!.idToken!,
      accessToken: supabaseAuth.accessToken,
    );
    return;
  }

  void logOut() {
    _supabaseGoogleSignIn.signOut();
    _firebaseAuth.signOut();
    _supabaseAuth.signOut();
  }
}
