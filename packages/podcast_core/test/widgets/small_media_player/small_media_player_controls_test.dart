import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:podcast_core/widgets/small_media_player/download_animation.dart';
import 'package:podcast_core/widgets/small_media_player/episode_progress_bar.dart';
import 'package:podcast_core/widgets/small_media_player/media_action_button.dart';
import 'package:podcast_core/widgets/small_media_player/play_pause_button.dart';
import 'package:podcast_core/widgets/small_media_player/small_media_player_controls.dart';

import '../../test_data_models/test_episode.dart'; // For default PlaybackState

// Mocks
class MockGoRouter extends Mock implements GoRouter {}
// Using test_data.testEpisode directly, so MockEpisode might not be needed unless for specific behaviors.

// Helper to create PlaybackState for PlayPauseButton dependency
PlaybackState createDefaultPlaybackState({bool playing = false}) {
  return PlaybackState(
    controls: [MediaControl.play, MediaControl.pause],
    processingState: AudioProcessingState.ready,
    playing: playing,
    updatePosition: Duration.zero,
    bufferedPosition: Duration.zero,
    speed: 1.0,
    queueIndex: 0,
    repeatMode: AudioServiceRepeatMode.none,
    shuffleMode: AudioServiceShuffleMode.none,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGoRouter mockGoRouter;
  late EpisodeWithStatus mockEpisodeData;

  setUp(() {
    mockGoRouter = MockGoRouter();
    final episode = TestEpisode.mocked(
      id: 'epTest1',
      podcastId: 'pdTest1',
      title: 'Test Episode Title for Controls',
      imageUrl: Uri.parse('https://example.com/test_controls_image.png'),
    );
    mockEpisodeData = EpisodeWithStatus(episode: episode, status: null);

    Future<void> pumpWidgetUnderTest(
      WidgetTester tester, {
      required AsyncValue<EpisodeWithStatus?>
      currentEpisodeWithStatusProviderValue,
      bool showSkipButtons = false,
      PlaybackState? audioState, // For audioStateProvider
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioPlayerPodProvider.overrideWithBuild(
              (_, _) => Future.value(mockEpisodeData),
            ),
            // Provide a default for audioStateProvider for the PlayPauseButton
            audioStateProvider.overrideWithValue(
              AsyncData(audioState ?? createDefaultPlaybackState()),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => Scaffold(
                    body: SmallMediaPlayerControls(
                      router: mockGoRouter,
                      showSkipButtons: showSkipButtons,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    group('SmallMediaPlayerControls Tests', () {
      testWidgets('renders correctly when playing an episode', (
        WidgetTester tester,
      ) async {
        await mockNetworkImagesFor(() async {
          await pumpWidgetUnderTest(
            tester,
            currentEpisodeWithStatusProviderValue: AsyncData(mockEpisodeData),
            showSkipButtons: false,
          );
          await tester.pumpAndSettle();

          expect(find.byType(SmallMediaPlayerControls), findsOneWidget);
          expect(
            find.byType(InkWell),
            findsOneWidget,
          ); // The whole control is tappable
          expect(find.byType(RoundedImage), findsOneWidget);
          expect(find.text(mockEpisodeData.episode.title), findsOneWidget);
          expect(find.byType(PlayPauseButton), findsOneWidget);
          expect(find.byType(EpisodeProgressBar), findsOneWidget);
          expect(
            find.byType(DownloadAnimation),
            findsOneWidget,
          ); // Assuming it's always there
          expect(
            find.byType(MediaActionButton),
            findsNothing,
          ); // showSkipButtons is false
        });
      });

      testWidgets('renders correctly with skip buttons', (
        WidgetTester tester,
      ) async {
        await mockNetworkImagesFor(() async {
          await pumpWidgetUnderTest(
            tester,
            currentEpisodeWithStatusProviderValue: AsyncData(mockEpisodeData),
            showSkipButtons: true,
          );
          await tester.pumpAndSettle();

          expect(find.byType(SmallMediaPlayerControls), findsOneWidget);
          expect(find.byType(MediaActionButton), findsNWidgets(2));
          // Could also find by specific icons if they are consistent:
          // expect(find.byIcon(Icons.skip_previous), findsOneWidget);
          // expect(find.byIcon(Icons.skip_next), findsOneWidget);
        });
      });

      testWidgets('renders loading state', (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await pumpWidgetUnderTest(
            tester,
            currentEpisodeWithStatusProviderValue: const AsyncLoading(),
          );
          await tester.pumpAndSettle(); // Settle after loading state

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          // Ensure other elements are not present
          expect(find.byType(RoundedImage), findsNothing);
          expect(find.text(mockEpisodeData.episode.title), findsNothing);
        });
      });

      testWidgets('renders error state', (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await pumpWidgetUnderTest(
            tester,
            currentEpisodeWithStatusProviderValue: const AsyncError(
              'Test Error',
              StackTrace.empty,
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text('Error loading episode'), findsOneWidget);
          // Ensure other elements are not present
          expect(find.byType(RoundedImage), findsNothing);
          expect(find.text(mockEpisodeData.episode.title), findsNothing);
        });
      });

      testWidgets('renders nothing playing state', (WidgetTester tester) async {
        await mockNetworkImagesFor(() async {
          await pumpWidgetUnderTest(
            tester,
            currentEpisodeWithStatusProviderValue: const AsyncData(
              null,
            ), // Null episode data
          );
          await tester.pumpAndSettle();

          expect(find.text('Nothing is playing right now'), findsOneWidget);
          // Ensure other elements are not present
          expect(find.byType(RoundedImage), findsNothing);
          expect(find.byType(PlayPauseButton), findsNothing);
          expect(find.byType(EpisodeProgressBar), findsNothing);
        });
      });
    });
  });
}
