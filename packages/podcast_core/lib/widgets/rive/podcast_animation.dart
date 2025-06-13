import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/extensions/map_extensions.dart';
import 'package:podcast_core/hooks/use_rive_setup.dart';
import 'package:podcast_core/hooks/use_state_machine_painter.dart';
import 'package:rive_native/rive_native.dart';

class PodcastAnimation extends HookWidget {
  final PodcastAnimationArtboard artboard;
  final Map<String, dynamic> params;

  const PodcastAnimation({
    super.key,
    required this.artboard,
    this.params = const {},
  });

  void updateControllerInputsViewModel(ViewModelInstance viewModel) {
    for (final (key, value) in params.records) {
      switch (value) {
        case final double value:
          viewModel.number(key)?.value = value;
        case final bool value:
          viewModel.boolean(key)?.value = value;
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
    final riveSetup = useRiveSetup(artboard);
    if (riveSetup == null) return Container();

    final stateMachinePainter = useStateMachinePainter(riveSetup);

    useEffect(() {
      if (riveSetup.viewModel case final viewModel?) {
        updateControllerInputsViewModel(viewModel);
      }
      if (stateMachinePainter.stateMachine case final stateMachine?) {
        updateControllerInputsStateMachine(stateMachine);
      }
      return null;
    }, [stateMachinePainter.stateMachine, riveSetup, ...params.records]);

    return RiveFileWidget(
      key: Key(artboard.name),
      file: riveSetup.file,
      artboardName: artboard.name,
      painter: stateMachinePainter,
    );
  }
}

enum PodcastAnimationArtboard {
  download('Download'),
  sortOrder('Sort order'),
  playPause('PlayPause');

  final String name;
  final String? stateMachineName;

  const PodcastAnimationArtboard(this.name, [this.stateMachineName]);
}
