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

  void updateControllerInputs(
    StateMachineController controller,
    Map<String, dynamic> params,
  ) {
    for (final (key, value) in params.records) {
      switch (value) {
        case final double value:
          controller.getNumberInput(key)?.value = value;
        case final bool value:
          controller.getBoolInput(key)?.value = value;
        default:
          continue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final riveAnimationController = useState<StateMachineController?>(null);
    // Disposing the controller when the widget is disposed
    useEffect(() => riveAnimationController.value?.dispose, [
      riveAnimationController.value,
    ]);

    useEffect(() {
      if (riveAnimationController.value case final controller?) {
        updateControllerInputs(controller, params);
      }
      return null;
    }, [riveAnimationController.value, ...params.records]);

    return RiveAnimation.asset(
      'packages/podcast_core/assets/animations/podcast.riv',
      artboard: artboard.name,
      onInit: (artboard) {
        final controller = riveAnimationController.value =
            StateMachineController.fromArtboard(
              artboard,
              this.artboard.stateMachineName,
            );
        artboard.addController(controller!);

        updateControllerInputs(controller, params);
      },
    );
  }
}

enum PodcastAnimationArtboard {
  download('Download', 'Download'),
  sortOrder('Sort order');

  final String name;
  final String stateMachineName;

  const PodcastAnimationArtboard(
    this.name, [
    this.stateMachineName = 'State Machine 1',
  ]);
}
