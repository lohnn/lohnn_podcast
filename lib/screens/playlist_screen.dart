import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get size from modal and height from child?
    return ListView(
      children: [
        AppBar(),
        const Text('HELLO'),
      ],
    );
  }
}
