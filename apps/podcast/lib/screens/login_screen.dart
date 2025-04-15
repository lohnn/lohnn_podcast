import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/helpers/platform_helpers.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/widgets/google_login_button/google_login_button.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginScreen extends HookConsumerWidget {
  final Widget? error;

  const LoginScreen({super.key, this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (error case final error?) error,
          if (isWeb)
            googleSignInButton()
          else
            IntrinsicWidth(
              child: SupaSocialsAuth(
                // nativeGoogleAuthConfig: NativeGoogleAuthConfig(),
                redirectUrl: Platform.isMacOS.thenOrNull(
                  () => 'lohnnpodcast://se.lohnn.poodcast/authenticated',
                ),
                socialProviders: const [
                  OAuthProvider.google,
                  // OAuthProvider.apple,
                ],
                showSuccessSnackBar: false,
                onSuccess: (response) {},
              ),
            ),
          if (kDebugMode)
            TextButton(
              onPressed: () {
                ref.read(userPodProvider.notifier).logInAnonymously();
              },
              child: const Text('Log in anonymously (DEBUG)'),
            ),
        ],
      ),
    );
  }
}
