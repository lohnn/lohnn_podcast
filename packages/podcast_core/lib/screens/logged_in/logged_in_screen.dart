import 'package:audio_service/audio_service.dart';
import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/intents/play_pause_intent.dart';
import 'package:podcast_core/providers/app_lifecycle_state_provider.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/providers/episode_color_scheme_provider.dart';
import 'package:podcast_core/screens/logged_in/episode_details_screen.dart';
import 'package:podcast_core/screens/logged_in/playlist_screen.dart';
import 'package:podcast_core/screens/logged_in/podcast_details_screen.dart';
import 'package:podcast_core/screens/logged_in/podcast_list_screen.dart';
import 'package:podcast_core/screens/logged_in/podcast_search_screen.dart';
import 'package:podcast_core/widgets/currently_playing_information.dart';
import 'package:podcast_core/widgets/media_player_bottom_sheet/small_media_player_controls.dart';
import 'package:podcast_core/widgets/podcast_actions.dart';

class LoggedInScreen extends HookConsumerWidget {
  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useMemoized(
      () => GoRouter(
        routes: [
          GoRoute(
            onExit: (context, _) async {
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
              ref.read(appLifecycleStatePodProvider.notifier).close();
              // Closing the app
              await SystemNavigator.pop();
              return false;
            },
            path: '/',
            builder: (context, state) => const PodcastListScreen(),
            routes: [
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
                builder:
                    (context, state) => PodcastDetailsScreen(
                      PodcastId(int.parse(state.pathParameters['podcastId']!)),
                    ),
                routes: [
                  GoRoute(
                    path: '/:episodeId',
                    builder:
                        (context, state) => EpisodeDetailsScreen(
                          podcastId: PodcastId(
                            int.parse(state.pathParameters['podcastId']!),
                          ),
                          episodeId: EpisodeId(
                            int.parse(state.pathParameters['episodeId']!),
                          ),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    final colorScheme =
        ref
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
            SingleActivator(
              LogicalKeyboardKey.mediaPlayPause,
            ): ChangePlayStateIntent(MediaAction.playPause),
            SingleActivator(
              LogicalKeyboardKey.mediaPlay,
            ): ChangePlayStateIntent(MediaAction.play),
            SingleActivator(
              LogicalKeyboardKey.mediaPause,
            ): ChangePlayStateIntent(MediaAction.pause),
            SingleActivator(
              LogicalKeyboardKey.mediaStop,
            ): ChangePlayStateIntent(MediaAction.pause),
          },
          child: AdaptiveLayout(
            bodyRatio: 0.7,
            bottomNavigation: SlotLayout(
              config: {
                Breakpoints.smallAndUp: SlotLayout.from(
                  key: const Key('LoggedInScreen.SmallMediaPlayerControls'),
                  builder:
                      (context) => SmallMediaPlayerControls(router: router),
                ),
                Breakpoints.mediumAndUp: SlotLayout.from(
                  key: const Key('LoggedInScreen.SmallMediaPlayerControls'),
                  builder:
                      (context) => SmallMediaPlayerControls(
                        router: router,
                        showSkipButtons: true,
                      ),
                ),
              },
            ),
            body: SlotLayout(
              config: {
                Breakpoints.smallAndUp: SlotLayout.from(
                  key: const Key('LoggedInScreen.Body'),
                  builder:
                      (context) => Router<Object>(
                        restorationScopeId: 'router',
                        routeInformationProvider:
                            router.routeInformationProvider,
                        routeInformationParser: router.routeInformationParser,
                        routerDelegate: router.routerDelegate,
                        backButtonDispatcher: router.backButtonDispatcher,
                      ),
                ),
              },
            ),
            secondaryBody: SlotLayout(
              config: {
                Breakpoints.mediumLargeAndUp: SlotLayout.from(
                  key: const Key('LoggedInScreen.SecondaryBody'),
                  builder:
                      (context) =>
                          CurrentlyPlayingInformation(onNavigate: router.go),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
