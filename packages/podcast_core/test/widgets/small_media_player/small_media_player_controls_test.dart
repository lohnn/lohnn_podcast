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
// Using test_data.testEpisode directly
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

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
  });

  Future<void> pumpWidgetUnderTest(
    WidgetTester tester, {
    required AsyncValue<EpisodeWithStatus?>
    currentEpisodeWithStatusProviderValue, // This should be for currentEpisodeWithStatusPod
    bool showSkipButtons = false,
    PlaybackState? audioState,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // This provider seems to be the one SmallMediaPlayerControls actually uses internally
          // to get the current episode information.
          currentEpisodeWithStatusPod.overrideWithValue(currentEpisodeWithStatusProviderValue),
          // audioPlayerPodProvider seems to be for actions, not state directly used by SMC for display.
          // It's okay to keep a default mock if actions are triggered.
          audioPlayerPodProvider.overrideWithBuild(
            (_, __) => Future.value(mockEpisodeData), // Or a mock if needed
          ),
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
    await tester.pumpAndSettle(); // Ensure UI is stable after initial pump
  }

  group('SmallMediaPlayerControls Accessibility Tests', () {
    testWidgets('renders correctly when playing an episode and is accessible', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          currentEpisodeWithStatusProviderValue: AsyncData(mockEpisodeData),
          showSkipButtons: false,
        );

        final controlsFinder = find.byType(SmallMediaPlayerControls);
        expect(controlsFinder, findsOneWidget);

        // Main InkWell
        final inkWellFinder = find.byType(InkWell);
        expect(inkWellFinder, findsOneWidget);
        expect(tester.getSize(inkWellFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(inkWellFinder),
          matchesSemantics(
            // Assuming the InkWell's label combines title for its main action (opening player)
            label: 'Open player details for ${mockEpisodeData.episode.title}',
            isTappable: true,
          ),
        );

        // RoundedImage
        final imageFinder = find.byType(RoundedImage);
        expect(imageFinder, findsOneWidget);
        expect(tester.getSize(imageFinder).width, greaterThanOrEqualTo(24.0)); // General size
        expect(tester.getSemantics(imageFinder), matchesSemantics(label: 'Episode image'));

        // Episode Title Text
        final titleFinder = find.text(mockEpisodeData.episode.title);
        expect(titleFinder, findsOneWidget);
        expect(tester.getSemantics(titleFinder), matchesSemantics(label: mockEpisodeData.episode.title, isInSemanticTree: true));

        // PlayPauseButton (presence checked, detailed a11y in its own test)
        expect(find.byType(PlayPauseButton), findsOneWidget);

        // EpisodeProgressBar
        final progressBarFinder = find.byType(EpisodeProgressBar);
        expect(progressBarFinder, findsOneWidget);
        // ProgressBar semantics: should describe its current state if possible, not focusable
        // This is a basic check; specific value/label would depend on EpisodeProgressBar's implementation
        expect(tester.getSemantics(progressBarFinder), matchesSemantics(isFocusable: false));

        // DownloadAnimation (presence, basic a11y if interactive)
        final downloadAnimationFinder = find.byType(DownloadAnimation);
        expect(downloadAnimationFinder, findsOneWidget);
        // If DownloadAnimation is interactive, it needs tap target & label. Assuming it's decorative or part of InkWell.

        await tester.testA11yGuidelines(label: 'Playing Episode State');
      });
    });

    testWidgets('renders with skip buttons and checks their accessibility', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          currentEpisodeWithStatusProviderValue: AsyncData(mockEpisodeData),
          showSkipButtons: true,
        );

        expect(find.byType(SmallMediaPlayerControls), findsOneWidget);
        final skipBackFinder = find.byIcon(Icons.skip_previous); // Assuming these are the icons
        final skipForwardFinder = find.byIcon(Icons.skip_next);

        expect(skipBackFinder, findsOneWidget);
        expect(tester.getSize(skipBackFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(skipBackFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
            tester.getSemantics(skipBackFinder),
            matchesSemantics(
                label: 'Skip back', isButton: true, hasTapAction: true));

        expect(skipForwardFinder, findsOneWidget);
        expect(tester.getSize(skipForwardFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(skipForwardFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
            tester.getSemantics(skipForwardFinder),
            matchesSemantics(
                label: 'Skip forward', isButton: true, hasTapAction: true));

        await tester.testA11yGuidelines(label: 'With Skip Buttons State');
      });
    });

    testWidgets('renders loading state and is accessible', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          currentEpisodeWithStatusProviderValue: const AsyncLoading(),
        );

        final progressIndicatorFinder = find.byType(CircularProgressIndicator);
        expect(progressIndicatorFinder, findsOneWidget);
        final indicatorSemantics = tester.getSemantics(progressIndicatorFinder);
        expect(indicatorSemantics.label, isEmpty); // Default indicator
        expect(indicatorSemantics.isFocusable, isFalse);

        await tester.testA11yGuidelines(label: 'Loading State');
      });
    });

    testWidgets('renders error state and is accessible', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          currentEpisodeWithStatusProviderValue: const AsyncError('Test Error', StackTrace.empty),
        );

        final errorTextFinder = find.text('Error loading episode');
        expect(errorTextFinder, findsOneWidget);
        expect(
            tester.getSemantics(errorTextFinder),
            matchesSemantics(label: 'Error loading episode', isInSemanticTree: true));

        await tester.testA11yGuidelines(label: 'Error State');
      });
    });

    testWidgets('renders nothing playing state and is accessible', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await pumpWidgetUnderTest(
          tester,
          currentEpisodeWithStatusProviderValue: const AsyncData(null),
        );

        final nothingPlayingFinder = find.text('Nothing is playing right now');
        expect(nothingPlayingFinder, findsOneWidget);
        expect(
            tester.getSemantics(nothingPlayingFinder),
            matchesSemantics(label: 'Nothing is playing right now', isInSemanticTree: true));

        await tester.testA11yGuidelines(label: 'Nothing Playing State');
      });
    });
  });
}
