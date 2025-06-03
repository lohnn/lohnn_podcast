import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/extensions/map_extensions.dart';
import 'package:rive/rive.dart';

class PodcastAnimation extends HookWidget {
  final PodcastAnimationArtboard artboard;
  final Map<String, dynamic> params;

  const PodcastAnimation({
    super.key,
    required this.artboard,
    this.params = const {},
  });

  @override
  Widget build(BuildContext context) {
    final riveAnimationController = useState<StateMachineController?>(null);

    void updateControllerInputs(
      StateMachineController controller,
      Map<String, dynamic> params,
    ) {
      for (final (key, value) in params.records) {
        switch (value) {
          case final double value:
            controller.findInput<double>(key)?.value = value;
          case final int value:
            controller.findInput<int>(key)?.value = value;
          case final bool value:
            controller.findInput<bool>(key)?.value = value;
          default:
            continue;
        }
      }
    }

    useEffect(() {
      if (riveAnimationControllervalue case final controller?) {
        updateControllerInputs(controller, params);
      }
      return null;
    }, [riveAnimationController.value, ...params.records]);

    // Disposing the controller when the widget is disposed
    if (riveAnimationController.value case final controller?) {
      useEffect(() => controller.dispose, [controller]);
    }
    return RiveAnimation.asset(
      'packages/podcast_core/assets/animations/podcast.riv',
      artboard: artboard.name,
      onInit: (artboard) {
        final controller = riveAnimationController.value =
            StateMachineController.fromArtboard(artboard, 'Download');
        artboard.addController(controller!);

        updateControllerInputs(controller, params);
      },
    );
  }
}

enum PodcastAnimationArtboard {
  download('Download'),
  sortOrder('Sort order');

  final String name;

  const PodcastAnimationArtboard(this.name);
}
