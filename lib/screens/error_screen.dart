import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/user_provider.dart';

class ErrorScreen extends ConsumerWidget {
  final VoidCallback onRefresh;
  final AsyncError<dynamic> state;

  const ErrorScreen(this.state, {super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint(state.toString());
    debugPrintStack(stackTrace: state.stackTrace);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong.'),
            TextButton(
              onPressed: onRefresh,
              child: const Text('Try reloading the page'),
            ),
            TextButton(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => const _LogOutDialog(),
                );
                if (shouldLogout ?? false) {
                  ref.read(userPodProvider.notifier).logOut();
                }
              },
              child: const Text('Log out?'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogOutDialog extends StatelessWidget {
  const _LogOutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log out?'),
      content: const Text("If you log out, you'll need to log in again."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Stay logged in'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Log out'),
        ),
      ],
    );
  }
}
