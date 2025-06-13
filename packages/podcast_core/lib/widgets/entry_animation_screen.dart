import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/hooks/use_rive_file.dart';
import 'package:rive_native/rive_native.dart';

class EntryAnimationScreen extends HookWidget {
  final Widget child;

  const EntryAnimationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final hasShownAnimation = useState(false);

    final file = useRiveAssetFile();

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
