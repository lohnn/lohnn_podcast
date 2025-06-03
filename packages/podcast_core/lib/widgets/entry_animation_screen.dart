import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive/rive.dart';

class EntryAnimationScreen extends HookWidget {
  final Widget child;
  const EntryAnimationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final hasShownAnimation = useState(false);

    return Stack(
      key: const ValueKey('EntryAnimationScreen.entryAnimation'),
      children: [
        child,
        if (!hasShownAnimation.value) ...[
          const Positioned.fill(
            child: RiveAnimation.asset(
              fit: BoxFit.cover,
              'packages/podcast_core/assets/animations/podcast_icon_background.riv',
              animations: ['Enter'],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: RiveAnimation.asset(
                'packages/podcast_core/assets/animations/podcast_icon_foreground.riv',
                animations: const ['Enter'],
                onInit: (artboard) {
                  final controller = StateMachineController.fromArtboard(
                    artboard,
                    'State Machine 1',
                  );
                  controller!.addEventListener((event) {
                    Future.microtask(() {
                      if (event.name == 'Done') {
                        hasShownAnimation.value = true;
                      }
                    });
                  });
                  artboard.addController(controller);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
