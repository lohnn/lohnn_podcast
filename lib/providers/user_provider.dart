import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcast/secrets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_provider.g.dart';

@riverpod
class UserPod extends _$UserPod {
  late GoTrueClient _supabaseAuth;

  // final _googleSignIn = GoogleSignIn();
  final _googleSignIn = GoogleSignIn(
    clientId: Secrets.googleClientId,
    serverClientId: Secrets.googleServerClientId,
  );

  @override
  Stream<User?> build() async* {
    _supabaseAuth = Supabase.instance.client.auth;

    yield _supabaseAuth.currentUser;
    await for (final _ in _supabaseAuth.onAuthStateChange) {
      yield _supabaseAuth.currentUser;
    }
  }

  Future<void> logIn() async {
    // Just making sure we are properly logged out before trying to log in.
    await logOut();

    if (Platform.isMacOS) {
      await _supabaseAuth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'lohnnpodcast://se.lohnn.poodcast/authenticated',
      );
      return;
    }

    // Supabase
    final supabaseAuth = await switch (await _googleSignIn.signInSilently(
      reAuthenticate: true,
    )) {
      final user? => user.authentication,
      _ => (await _googleSignIn.signIn())?.authentication,
    };
    await _supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: supabaseAuth!.idToken!,
      accessToken: supabaseAuth.accessToken,
    );
    return;
  }

  Future<void> logOut() async {
    await [_googleSignIn.signOut(), _supabaseAuth.signOut()].wait;
  }
}
