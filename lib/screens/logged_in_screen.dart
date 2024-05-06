import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/screens/logged_in/episode_list_screen.dart';
import 'package:podcast/screens/logged_in/podcast_list_screen.dart';
import 'package:podcast/widgets/podcast_actions.dart';
import 'package:podcast/widgets/small_media_player_controls.dart';

class LoggedInScreen extends HookWidget {
  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final router = useMemoized(
      () => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const PodcastListScreen(),
          ),
          GoRoute(
            path: '/podcast',
            builder: (context, state) => EpisodeListScreen(
              state.extra! as QueryDocumentSnapshot<Podcast>,
            ),
          ),
        ],
      ),
    );

    return PodcastActions(
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.mediaPlayPause):
              ChangePlayStateIntent(
            PlayState.toggle,
          ),
          SingleActivator(LogicalKeyboardKey.mediaPlay): ChangePlayStateIntent(
            PlayState.play,
          ),
          SingleActivator(LogicalKeyboardKey.mediaPause): ChangePlayStateIntent(
            PlayState.pause,
          ),
          SingleActivator(LogicalKeyboardKey.mediaStop): ChangePlayStateIntent(
            PlayState.pause,
          ),
        },
        child: Scaffold(
          // bottomSheet: const MediaBottomSheet(),
          bottomNavigationBar: const SmallMediaPlayerControls(),
          body: Router<Object>(
            restorationScopeId: 'router',
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            backButtonDispatcher: router.backButtonDispatcher,
          ),
        ),
      ),
    );
    return const Navigator(
      pages: [
        MaterialPage(child: PodcastListScreen()),
      ],
    );
  }
}

class MediaBottomSheet extends StatefulWidget {
  const MediaBottomSheet({super.key});

  @override
  State<MediaBottomSheet> createState() => _MediaBottomSheetState();
}

class _MediaBottomSheetState extends State<MediaBottomSheet>
    with SingleTickerProviderStateMixin {
  late final _bottomSheetAnimationController =
      BottomSheet.createAnimationController(this);

  @override
  void dispose() {
    _bottomSheetAnimationController.dispose();
    super.dispose();
  }

  double _sheetPosition = 0.25;
  final double _dragSensitivity = 600;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      shouldCloseOnMinExtent: false,
      initialChildSize: _sheetPosition,
      builder: (context, scrollController) {
        return Column(
          children: [
            Grabber(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _sheetPosition -= details.delta.dy / _dragSensitivity;
                  if (_sheetPosition < 0.25) {
                    _sheetPosition = 0.25;
                  }
                  if (_sheetPosition > 1.0) {
                    _sheetPosition = 1.0;
                  }
                });
              },
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Item $index',
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A draggable widget that accepts vertical drag gestures
/// and this is only visible on desktop and web platforms.
class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;

  bool get isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              width: 32.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
