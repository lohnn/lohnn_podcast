import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:podcast_core/extensions/map_extensions.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import 'package:rive_native/rive_native.dart' as rive show File;
import 'package:rive_native/rive_native.dart';

class NewPodcastAnimation extends HookWidget {
  final PodcastAnimationArtboard artboard;
  final Map<String, dynamic> params;

  const NewPodcastAnimation({
    super.key,
    required this.artboard,
    this.params = const {},
  });

  void updateControllerInputs(StateMachine stateMachine) {
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
    final riveStateMachine = useState<StateMachine?>(null);
    // Disposing the controller when the widget is disposed
    useEffect(() => riveStateMachine.value?.dispose, [riveStateMachine.value]);

    useEffect(() {
      if (riveStateMachine.value case final controller?) {
        updateControllerInputs(controller);
      }
      return null;
    }, [riveStateMachine.value, ...params.records]);

    final fileFuture = useMemoized(
      () => rive.File.asset(
        'packages/podcast_core/assets/animations/podcast.riv',
        riveFactory: Factory.rive,
      ),
    );
    final file = useFuture(fileFuture).data;

    final stateMachinePainter = useMemoized(
      () => StateMachinePainter(
        withStateMachine: (stateMachine) {
          unawaited(
            Future(() {
              riveStateMachine.value = stateMachine;
            }),
          );
          updateControllerInputs(stateMachine);
        },
        stateMachineName: artboard.stateMachineName,
      ),
    );

    if (file == null) return Container();

    useEffect(() => file.dispose);

    return RiveFileWidget(
      key: Key(artboard.name),
      file: file,
      artboardName: artboard.name,
      painter: stateMachinePainter,
    );
  }
}
