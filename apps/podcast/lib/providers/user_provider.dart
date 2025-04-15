import 'package:google_sign_in/google_sign_in.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/helpers/platform_helpers.dart';
import 'package:podcast/secrets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_provider.g.dart';

@riverpod
class UserPod extends _$UserPod {
  late GoTrueClient _supabaseAuth;

  late GoogleSignIn _googleSignIn;

  @override
  Stream<User?> build() async* {
    listenSelf((oldValue, newValue) {
      // Check in once, when the user is logged in
      if (newValue.valueOrNull != null && oldValue != newValue) {
        Repository().checkInUser();
      }
    });

    if (isWeb) {
      _googleSignIn = GoogleSignIn(clientId: Secrets.googleServerClientId);

      ref.onDispose(
        _googleSignIn.onCurrentUserChanged.whereNotNull().listen((user) async {
          final authentication = await user.authentication;
          await _authenticateSupabase(authentication);
        }).cancel,
      );
    }

    _supabaseAuth = Supabase.instance.client.auth;

    yield _supabaseAuth.currentUser;
    await for (final _ in _supabaseAuth.onAuthStateChange) {
      yield _supabaseAuth.currentUser;
    }
  }

  Future<void> logInAnonymously() async {
    // Just making sure we are properly logged out before trying to log in.
    await logOut();
    await _supabaseAuth.signInAnonymously();
  }

  Future<void> _authenticateSupabase(
    GoogleSignInAuthentication authentication,
  ) {
    return _supabaseAuth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: authentication.idToken!,
      accessToken: authentication.accessToken,
    );
  }

  Future<void> logOut() async {
    await [_googleSignIn.signOut(), _supabaseAuth.signOut()].wait;
  }
}
