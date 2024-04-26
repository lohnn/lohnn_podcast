import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/firebase/user_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
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
