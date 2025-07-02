import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/extensions/map_extensions.dart';
import 'package:podcast_core/hooks/use_state_machine_painter.dart';
import 'package:podcast_core/widgets/rive/podcast_animation_config.dart';
import 'package:rive_native/rive_native.dart';

class PodcastAnimation extends HookWidget {
  final PodcastAnimationConfig animationArtboard;

  const PodcastAnimation({super.key, required this.animationArtboard});

  static void updateControllerInputsViewModel(
    ViewModelInstance viewModel,
    Map<String, dynamic> params,
  ) {
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

  static void updateControllerInputsStateMachine(
    StateMachine stateMachine,
    Map<String, dynamic> params,
  ) {
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

  Widget _buildWidget(BuildContext context) {
    final response = useStateMachinePainter(animationArtboard);

    if (response == null) return Container();

    final (artboard, stateMachinePainter, viewModel) = response;

    final params = animationArtboard.params(context);
    useEffect(
      () {
        if (viewModel case final viewModel?) {
          updateControllerInputsViewModel(viewModel, params);
        }
        if (stateMachinePainter.stateMachine case final stateMachine?) {
          updateControllerInputsStateMachine(stateMachine, params);
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

  @override
  Widget build(BuildContext context) {
    if (animationArtboard.isIcon) {
      final theme = Theme.of(context);
      return SizedBox(
        height: theme.iconTheme.size ?? const IconThemeData.fallback().size,
        width: theme.iconTheme.size ?? const IconThemeData.fallback().size,
        child: _buildWidget(context),
      );
    } else {
      return _buildWidget(context);
    }
  }
}

// enum PodcastAnimationArtboard {
//   delete('Delete'),
//   download('Download'),
//   idleLogo('Icon idle animation'),
//   playPause('PlayPause'),
//   sortOrder('Sort order'),
//   queue('Queue');
//
//   final String name;
//
//   const PodcastAnimationArtboard(this.name);
// }
