import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import 'package:rive_native/rive_native.dart';

final class RiveHookException implements Exception {
  final String message;

  const RiveHookException(this.message);

  @override
  String toString() {
    return 'RiveHookException{message: $message}';
  }
}

(Artboard, StateMachinePainter, ViewModelInstance?)? useStateMachinePainter(
  PodcastAnimationArtboard artboard,
) {
  return use(_RiveStateMachinePainterHook(artboard, keys: [artboard]));
}

class _RiveStateMachinePainterHook
    extends Hook<(Artboard, StateMachinePainter, ViewModelInstance?)?> {
  final PodcastAnimationArtboard artboard;

  const _RiveStateMachinePainterHook(this.artboard, {required super.keys});

  @override
  _RiveStateMachinePainterHookState createState() =>
      _RiveStateMachinePainterHookState();
}

class _RiveStateMachinePainterHookState
    extends
        HookState<
          (Artboard, StateMachinePainter, ViewModelInstance?)?,
          _RiveStateMachinePainterHook
        > {
  StateMachinePainter? stateMachinePainter;
  ViewModelInstance? viewModelInstance;
  Artboard? artboard;
  File? riveFile;

  @override
  void initHook() {
    unawaited(_init());
    super.initHook();
  }

  Future<void> _init() async {
    final riveFile = this.riveFile = await _loadFile();
    if (riveFile == null) {
      throw const RiveHookException('Could not open Rive file');
    }

    final artboard = this.artboard = riveFile.artboard(hook.artboard.name);
    if (artboard == null) {
      throw RiveHookException('Artboard not found: ${hook.artboard.name}');
    }

    stateMachinePainter = RivePainter.stateMachine(
      withStateMachine: (stateMachine) {
        final viewModel = riveFile.defaultArtboardViewModel(artboard);
        if (viewModel == null) return;

        final viewModelInstance = viewModel.createDefaultInstance();
        if (viewModelInstance == null) return;

        stateMachine.bindViewModelInstance(viewModelInstance);
        unawaited(
          Future(
            () => setState(() {
              this.viewModelInstance = viewModelInstance;
            }),
          ),
        );
      },
    );
    setState(() {});
  }

  Future<File?> _loadFile() {
    return File.asset(
      'packages/podcast_core/assets/animations/podcast.riv',
      riveFactory: Factory.rive,
    );
  }

  @override
  (Artboard, StateMachinePainter, ViewModelInstance?)? build(
    BuildContext context,
  ) {
    final artboard = this.artboard;
    final stateMachinePainter = this.stateMachinePainter;
    if (artboard == null || stateMachinePainter == null) {
      return null; // Return null if the artboard or painter is not ready
    }
    return (artboard, stateMachinePainter, viewModelInstance);
  }

  @override
  void dispose() {
    artboard?.dispose();
    stateMachinePainter?.dispose();
    super.dispose();
  }
}
