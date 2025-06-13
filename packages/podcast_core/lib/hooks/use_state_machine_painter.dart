import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/hooks/use_rive_setup.dart';
import 'package:rive_native/rive_native.dart';

StateMachinePainter useStateMachinePainter(RiveSetup riveSetup) {
  return use(_RiveStateMachinePainterHook(riveSetup));
}

class _RiveStateMachinePainterHook extends Hook<StateMachinePainter> {
  final RiveSetup riveSetup;

  const _RiveStateMachinePainterHook(this.riveSetup);

  @override
  _RiveStateMachinePainterHookState createState() =>
      _RiveStateMachinePainterHookState();
}

class _RiveStateMachinePainterHookState
    extends HookState<StateMachinePainter, _RiveStateMachinePainterHook> {
  late final stateMachinePainter = RivePainter.stateMachine(
    stateMachineName: hook.riveSetup.artboard.stateMachineName,
    withStateMachine: (stateMachine) {
      final viewModelInstance = hook.riveSetup.viewModel;
      if (viewModelInstance != null) {
        stateMachine.bindViewModelInstance(viewModelInstance);
      }
      unawaited(Future(() => setState(() {})));
    },
  );

  @override
  StateMachinePainter build(BuildContext context) {
    return stateMachinePainter;
  }

  @override
  void dispose() {
    stateMachinePainter.dispose();
    super.dispose();
  }
}
