import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import 'package:rive_native/rive_native.dart';

@immutable
final class RiveSetup {
  final File file;
  final PodcastAnimationArtboard artboard;
  final ViewModelInstance? viewModel;

  const RiveSetup(this.file, this.artboard, this.viewModel);

  void dispose() {
    file.dispose();
    viewModel?.dispose();
  }
}

final class RiveHookException implements Exception {
  final String message;

  const RiveHookException(this.message);

  @override
  String toString() {
    return 'RiveHookException{message: $message}';
  }
}

RiveSetup? useRiveSetup(PodcastAnimationArtboard artboard) {
  return use(_RiveSetupHook(artboard));
}

class _RiveSetupHook extends Hook<RiveSetup?> {
  final PodcastAnimationArtboard artboard;

  const _RiveSetupHook(this.artboard);

  @override
  _RiveSetupHookState createState() => _RiveSetupHookState();
}

class _RiveSetupHookState extends HookState<RiveSetup?, _RiveSetupHook> {
  RiveSetup? riveSetup;

  @override
  void initHook() {
    File.asset(
      'packages/podcast_core/assets/animations/podcast.riv',
      riveFactory: Factory.rive,
    ).then((file) {
      if (file == null) {
        throw const RiveHookException('Could not open Rive file');
      }

      final artboard = file.artboard(hook.artboard.name);
      if (artboard == null) {
        throw RiveHookException('Artboard not found: ${hook.artboard}');
      }

      final viewModel = file
          .defaultArtboardViewModel(artboard)
          ?.createDefaultInstance();

      setState(() {
        riveSetup = RiveSetup(file, hook.artboard, viewModel);
      });
    });
    super.initHook();
  }

  @override
  RiveSetup? build(BuildContext context) {
    return riveSetup;
  }

  @override
  void dispose() {
    riveSetup?.dispose();
    super.dispose();
  }
}
