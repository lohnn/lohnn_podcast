import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive_native/rive_native.dart';

File? useRiveAssetFile() {
  return use(const _RiveFileHook());
}

class _RiveFileHook extends Hook<File?> {
  const _RiveFileHook();

  @override
  _RiveFileHookState createState() => _RiveFileHookState();
}

class _RiveFileHookState extends HookState<File?, _RiveFileHook> {
  File? file;

  @override
  void initHook() {
    File.asset(
      'packages/podcast_core/assets/animations/podcast.riv',
      riveFactory: Factory.rive,
    ).then((file) {
      setState(() => this.file = file);
    });
    super.initHook();
  }

  @override
  File? build(BuildContext context) {
    return file;
  }

  @override
  void dispose() {
    file?.dispose();
    super.dispose();
  }
}
