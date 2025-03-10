import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GetTextDialog extends HookWidget {
  final String title;
  final String textFieldHint;

  const GetTextDialog({
    super.key,
    required this.title,
    required this.textFieldHint,
  });

  factory GetTextDialog.addPodcastDialog() {
    return const GetTextDialog(title: 'Add podcast', textFieldHint: 'Rss url');
  }

  factory GetTextDialog.importListenedEpisodesDialog() {
    return const GetTextDialog(
      title: 'Import listened episodes',
      textFieldHint: 'Listened episodes JSON url',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void finish(String text) {
      if (text.isEmpty) return;
      Navigator.pop(context, text);
    }

    return AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        controller: textController,
        decoration: InputDecoration(hintText: textFieldHint),
        onSubmitted: finish,
      ),
      actions: [
        TextButton(
          onPressed: () => finish(textController.text),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
