import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/gen/strings.g.dart';

class GetTextDialog extends HookWidget {
  final String title;
  final String textFieldHint;

  const GetTextDialog({
    super.key,
    required this.title,
    required this.textFieldHint,
  });

  factory GetTextDialog.addPodcastDialog(BuildContext context) {
    return GetTextDialog(
      title: context.t.addPodcastDialog.title,
      textFieldHint: context.t.addPodcastDialog.textFieldHint,
    );
  }

  factory GetTextDialog.importListenedEpisodesDialog(BuildContext context) {
    return GetTextDialog(
      title: context.t.importListenedEpisodesDialog.title,
      textFieldHint: context.t.importListenedEpisodesDialog.textFieldHint,
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
          child: Text(context.t.ok),
        ),
      ],
    );
  }
}
