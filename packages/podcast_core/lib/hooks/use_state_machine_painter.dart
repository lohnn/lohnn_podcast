import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/widgets/rive/podcast_animation_config.dart';
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
  PodcastAnimationConfig config,
) {
  return use(
    _RiveStateMachinePainterHook(
      config.artboardName,
      keys: [config.artboardName],
    ),
  );
}

class _RiveStateMachinePainterHook
    extends Hook<(Artboard, StateMachinePainter, ViewModelInstance?)?> {
  final String artboardName;

  const _RiveStateMachinePainterHook(this.artboardName, {required super.keys});

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

    final artboard = this.artboard = riveFile.artboard(hook.artboardName);
    if (artboard == null) {
      throw RiveHookException('Artboard not found: ${hook.artboardName}');
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
    stateMachinePainter?.dispose();
    viewModelInstance?.dispose();
    artboard?.dispose();
    riveFile?.dispose();
    super.dispose();
  }
}
