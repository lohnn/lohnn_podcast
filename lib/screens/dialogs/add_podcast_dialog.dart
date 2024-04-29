import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddPodcastDialog extends HookWidget {
  const AddPodcastDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void finish(String text) {
      if (text.isEmpty) return;
      Navigator.pop(context, text);
    }

    return AlertDialog(
      title: const Text('Add podcast'),
      content: TextField(
        autofocus: true,
        controller: textController,
        decoration: const InputDecoration(hintText: 'Rss url'),
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
