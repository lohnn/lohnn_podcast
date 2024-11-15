import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/providers/episode_color_scheme_provider.dart';
import 'package:podcast/providers/socket_provider.dart';
import 'package:podcast/screens/logged_in/episode_details_screen.dart';
import 'package:podcast/screens/logged_in/episode_list_screen.dart';
import 'package:podcast/screens/logged_in/podcast_list_screen.dart';
import 'package:podcast/screens/playlist_screen.dart';
import 'package:podcast/screens/podcast_search_screen.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/small_media_player_controls.dart';
import 'package:podcast/widgets/podcast_actions.dart';

class LoggedInScreen extends HookConsumerWidget {
  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useMemoized(
      () => GoRouter(
        routes: [
          GoRoute(
            onExit: (context, __) async {
              final shouldClose = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );

              if (!(shouldClose ?? false)) return false;

              // Kill the app if the user tries to pop the main screen
              // Stopping the audio player
              await ref.read(audioPlayerPodProvider.notifier).dispose();
              // Stopping all sockets
              ref.read(socketPodProvider.notifier).close();
              // Closing the app
              SystemNavigator.pop();
              return false;
            },
            path: '/',
            builder: (context, state) => const PodcastListScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const PodcastSearchScreen(),
          ),
          GoRoute(
            path: '/playlist',
            builder: (context, state) => const PlaylistScreen(),
          ),
          GoRoute(
            path: '/:podcastId',
            builder: (context, state) => EpisodeListScreen(
              state.pathParameters['podcastId']!,
            ),
            routes: [
              GoRoute(
                path: ':episodeId',
                builder: (context, state) => EpisodeDetailsScreen(
                  podcastId: state.pathParameters['podcastId']!,
                  episodeId:
                      Uri.encodeComponent(state.pathParameters['episodeId']!),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final colorScheme = ref
        .watch(
          currentPlayingEpisodeColorSchemeProvider(
            Theme.of(context).brightness,
          ),
        )
        .valueOrNull;

    return AnimatedTheme(
      key: const ValueKey('LoggedInScreen.theme'),
      data: Theme.of(context).copyWith(colorScheme: colorScheme),
      child: PodcastActions(
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.mediaPlayPause):
                ChangePlayStateIntent(
              MediaAction.playPause,
            ),
            SingleActivator(LogicalKeyboardKey.mediaPlay):
                ChangePlayStateIntent(
              MediaAction.play,
            ),
            SingleActivator(LogicalKeyboardKey.mediaPause):
                ChangePlayStateIntent(
              MediaAction.pause,
            ),
            SingleActivator(LogicalKeyboardKey.mediaStop):
                ChangePlayStateIntent(
              MediaAction.pause,
            ),
          },
          child: Scaffold(
            // bottomSheet: const MediaBottomSheet(),
            bottomNavigationBar: SmallMediaPlayerControls(
              router: router,
            ),
            body: Router<Object>(
              restorationScopeId: 'router',
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              backButtonDispatcher: router.backButtonDispatcher,
            ),
          ),
        ),
      ),
    );
  }
}
