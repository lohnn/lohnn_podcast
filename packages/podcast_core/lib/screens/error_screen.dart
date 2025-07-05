import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/gen/strings.g.dart';

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
            Text(context.t.errorScreen.somethingWentWrong),
            TextButton(
              onPressed: onRefresh,
              child: Text(context.t.errorScreen.tryReloading),
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
      title: Text(context.t.logOutDialog.title),
      content: Text(context.t.logOutDialog.content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(context.t.logOutDialog.stayLoggedIn),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(context.t.logOutDialog.logOut),
        ),
      ],
    );
  }
}
