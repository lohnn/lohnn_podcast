import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/extensions/map_extensions.dart';
import 'package:podcast_core/hooks/use_state_machine_painter.dart';
import 'package:rive_native/rive_native.dart';

class PodcastAnimation extends HookWidget {
  final PodcastAnimationArtboard animationArtboard;
  final Map<String, dynamic> params;

  const PodcastAnimation({
    super.key,
    required this.animationArtboard,
    this.params = const {},
  });

  void updateControllerInputsViewModel(ViewModelInstance viewModel) {
    for (final (key, value) in params.records) {
      switch (value) {
        case final double value:
          viewModel.number(key)?.value = value;
        case final bool value:
          viewModel.boolean(key)?.value = value;
        case final Color value:
          viewModel.color(key)?.value = value;
        default:
          continue;
      }
    }
  }

  void updateControllerInputsStateMachine(StateMachine stateMachine) {
    for (final (key, value) in params.records) {
      switch (value) {
        case final double value:
          stateMachine.number(key)?.value = value;
        case final bool value:
          stateMachine.boolean(key)?.value = value;
        default:
          continue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = useStateMachinePainter(animationArtboard);

    if (response == null) return Container();

    final (artboard, stateMachinePainter, viewModel) = response;

    useEffect(
      () {
        if (viewModel case final viewModel?) {
          updateControllerInputsViewModel(viewModel);
        }
        if (stateMachinePainter.stateMachine case final stateMachine?) {
          updateControllerInputsStateMachine(stateMachine);
        }
        // This seems to be necessary to ensure the inputs are updated.
        // Preferably, this should be done in the state machine's update method.
        stateMachinePainter.scheduleRepaint();
        return null;
      },
      [
        artboard,
        stateMachinePainter,
        stateMachinePainter.stateMachine,
        viewModel,
        ...params.records,
      ],
    );

    return RiveArtboardWidget(artboard: artboard, painter: stateMachinePainter);
  }
}

enum PodcastAnimationArtboard {
  download('Download'),
  sortOrder('Sort order'),
  playPause('PlayPause');

  final String name;

  const PodcastAnimationArtboard(this.name);
}
