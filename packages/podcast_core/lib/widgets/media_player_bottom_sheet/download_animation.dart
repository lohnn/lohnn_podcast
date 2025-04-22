import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/episode_loader_provider.dart';
import 'package:rive/rive.dart';

class DownloadAnimation extends HookConsumerWidget {
  const DownloadAnimation({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadRiveController = useState<StateMachineController?>(null);

    final progress = ref.watch(
      episodeLoaderProvider(
        episode,
      ).select((e) => e.valueOrNull?.currentDownloadProgress),
    );

    useEffect(() {
      if ((downloadRiveController.value, progress) case (
        final controller?,
        final progress?,
      )) {
        controller.getNumberInput('Progress')?.value = progress;
      }
      return null;
    }, [downloadRiveController.value, progress]);

    // Disposing the controller when the widget is disposed
    if (downloadRiveController.value case final controller?) {
      useEffect(() => controller.dispose, [controller]);
    }

    return RiveAnimation.asset(
      'assets/animations/podcast.riv',
      artboard: 'Download',
      onInit: (artboard) {
        final controller =
            downloadRiveController.value = StateMachineController.fromArtboard(
              artboard,
              'Download',
            );
        artboard.addController(controller!);

        final currentDownloadProgress = ref.read(
          episodeLoaderProvider(
            episode,
          ).select((e) => e.valueOrNull?.currentDownloadProgress),
        );
        if (currentDownloadProgress != null) {
          controller.getNumberInput('Progress')!.value =
              currentDownloadProgress;
        }
      },
    );
  }
}
