import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/widgets/google_login_button/google_login_button.dart';

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
          if (kIsWeb)
            googleSignInButton()
          else
            TextButton(
              onLongPress: switch (kDebugMode) {
                true =>
                  () => ref.read(userPodProvider.notifier).logInAnonymously(),
                false => null,
              },
              onPressed: () {
                ref.read(userPodProvider.notifier).logIn();
              },
              child: const Text('Log in'),
            ),
        ],
      ),
    );
  }
}
