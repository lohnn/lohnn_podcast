import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/gen/l10n.dart';

class ErrorScreen extends ConsumerWidget {
  final VoidCallback onRefresh;
  final AsyncError<dynamic> state;

  const ErrorScreen(this.state, {super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    debugPrint(state.toString());
    debugPrintStack(stackTrace: state.stackTrace);
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t.errorScreen.somethingWentWrong),
            TextButton(
              onPressed: onRefresh,
              child: Text(t.errorScreen.tryReloading),
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
    final t = Translations.of(context);
    return AlertDialog(
      title: Text(t.logOutDialog.title),
      content: Text(t.logOutDialog.content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(t.logOutDialog.stayLoggedIn),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(t.logOutDialog.logOut),
        ),
      ],
    );
  }
}
