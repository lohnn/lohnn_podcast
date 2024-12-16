import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_provider.g.dart';

@riverpod
class UserPod extends _$UserPod {
  late GoTrueClient _supabaseAuth;

  // final _googleSignIn = GoogleSignIn();
  final _googleSignIn = GoogleSignIn(
    clientId: const String.fromEnvironment('CLIENT_ID'),
    serverClientId: const String.fromEnvironment('SERVER_CLIENT_ID'),
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
    // TODO(lohnn): Figure out how to get this working
    // await _supabaseAuth.signInWithOAuth(
    //   OAuthProvider.google,
    //   redirectTo: 'lohnnpodcast://se.lohnn.poodcast/authenticated',
    // );
    // print('hello');
    // return;

    // Supabase
    final supabaseAuth = await switch (
        await _googleSignIn.signInSilently(reAuthenticate: true)) {
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

  void logOut() {
    _googleSignIn.signOut();
    _supabaseAuth.signOut();
  }
}
