import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive_native/rive_native.dart' as rive show File;
import 'package:rive_native/rive_native.dart';

class EntryAnimationScreen extends HookWidget {
  final Widget child;

  const EntryAnimationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final hasShownAnimation = useState(false);

    final fileFuture = useMemoized(
      () => rive.File.asset(
        'packages/podcast_core/assets/animations/podcast.riv',
        riveFactory: Factory.rive,
      ),
    );
    final file = useFuture(fileFuture).data;
    if (file == null) return Container();

    final stateMachinePainter = useMemoized(
      () => StateMachinePainter(
        fit: Fit.layout,
        withStateMachine: (stateMachine) {
          stateMachine.addEventListener((event) {
            if (event.name == 'Done') {
              hasShownAnimation.value = true;
              file.dispose();
              stateMachine.dispose();
            }
          });
        },
      ),
    );

    return Stack(
      key: const ValueKey('EntryAnimationScreen.entryAnimation'),
      children: [
        child,
        if (!hasShownAnimation.value)
          Positioned.fill(
            child: RiveFileWidget(
              artboardName: 'New open app',
              file: file,
              painter: stateMachinePainter,
            ),
          ),
      ],
    );
  }
}
