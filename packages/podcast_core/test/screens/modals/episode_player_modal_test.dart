import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:audio_service/audio_service.dart';

import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/screens/modals/episode_player_modal.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:podcast_core/widgets/small_media_player/play_pause_button.dart'; // For presence check
import 'package:podcast_core/widgets/small_media_player/media_action_button.dart'; // For presence check
import 'package:podcast_core/widgets/small_media_player/episode_progress_bar.dart'; // For presence check
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'; // For description

import '../../../test_data_models/test_episode.dart';
import '../../../test_data_models/test_podcast.dart';
import '../../helpers/widget_tester_helpers.dart';

// --- Mocks ---
class MockAudioPlayerPod extends Mock implements AudioPlayerPod {
  // Mock the specific getter if it's directly on AudioPlayerPod state
  // For this example, we'll assume currentlyPlayingEpisodeWithPodcast is a selector or a method.
  // If it's a direct property 'state.currentlyPlayingEpisodeWithPodcast', mocking the state is harder.
  // It's more common to mock methods or simpler providers.
  // Let's assume we can control what 'currentlyPlayingEpisodeWithPodcastProvider' (a conceptual provider) returns.
  // For now, the override in pumpEpisodePlayerModal will handle this.
}

// Helper to create PlaybackState
PlaybackState createPlaybackState({
  bool playing = false,
  AudioProcessingState processingState = AudioProcessingState.ready,
  Duration position = Duration.zero,
  Duration? totalDuration, // Add totalDuration for progress bar context
  String? mediaId,
}) {
  return PlaybackState(
    controls: [
      MediaControl.play, MediaControl.pause,
      MediaControl.skipToPrevious, MediaControl.skipToNext,
      MediaControl.fastForward, MediaControl.rewind,
    ],
    processingState: processingState,
    playing: playing,
    updatePosition: position,
    bufferedPosition: totalDuration != null ? position + const Duration(seconds: 15) : Duration.zero,
    speed: 1.0,
    queueIndex: 0,
    mediaItem: mediaId != null ? MediaItem(id: mediaId, duration: totalDuration, title: 'Mock Media Item') : null,
    currentMediaItemDuration: totalDuration, // Ensure this is set for progress bar
  );
}


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEpisode testEpisode;
  late TestPodcast testPodcast;
  late MockAudioPlayerPod mockAudioPlayerPod;

  setUp(() {
    testEpisode = TestEpisode.mocked(
      id: 'ep1',
      podcastId: 'pd1',
      title: 'The Grand Episode',
      description: '<p>An episode about <b>grand</b> things.</p>',
      duration: const Duration(minutes: 30),
      imageUrl: Uri.parse('http://example.com/episode_artwork.png'),
    );
    testPodcast = TestPodcast.mocked(
      id: 'pd1',
      title: 'Podcast of Grandeur',
      author: 'The Narrator',
      artwork: 'http://example.com/podcast_grand_artwork.png',
    );
    mockAudioPlayerPod = MockAudioPlayerPod();

    // Stub actions
    when(() => mockAudioPlayerPod.play()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.pause()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.fastForward()).thenAnswer((_) async {});
    when(() => mockAudioPlayerPod.rewind()).thenAnswer((_) async {});
    // Add other actions like skipToNext, skipToPrevious if tested directly
  });

  Future<void> pumpEpisodePlayerModal(
    WidgetTester tester, {
    required AsyncValue<(Episode, Podcast)?> episodeWithPodcastAsyncValue,
    required PlaybackState playbackState,
  }) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          ProviderScope(
            overrides: [
              // This is the key provider EpisodePlayerModal watches for its main data.
              currentlyPlayingEpisodeWithPodcastProvider.overrideWithValue(episodeWithPodcastAsyncValue),
              audioStateProvider.overrideWithValue(AsyncData(playbackState)),
              audioPlayerPodProvider.overrideWith((ref) => mockAudioPlayerPod),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const EpisodePlayerModal(),
                      );
                    },
                    child: const Text('Show Player Modal'),
                  ),
                ),
              ),
            ),
          ),
        ));
    await tester.tap(find.text('Show Player Modal'));
    await tester.pumpAndSettle(); // Modal animation
  }

  group('EpisodePlayerModal Accessibility Tests', () {
    testWidgets(
        'Modal with episode playing (paused): displays info, controls, correct semantics, and meets a11y',
        (tester) async {
      final playingData = AsyncData<(Episode, Podcast)>((testEpisode, testPodcast));
      final pausedState = createPlaybackState(
          playing: false,
          position: const Duration(minutes: 5),
          totalDuration: testEpisode.duration,
          mediaId: testEpisode.id.id);

      await pumpEpisodePlayerModal(tester,
          episodeWithPodcastAsyncValue: playingData,
          playbackState: pausedState);

      // Verify Modal Semantics
      final modalFinder = find.byType(EpisodePlayerModal);
      expect(modalFinder, findsOneWidget);
      // AlertDialog/ModalBottomSheet handle isModal. Label might be derived from content.
      // A specific semantic label for the whole modal can be checked if explicitly set.
      // For now, relying on testA11yGuidelines for overall modal announcement.

      // Verify Displayed Information
      expect(find.text(testEpisode.title), findsOneWidget);
      expect(find.text(testPodcast.author!), findsOneWidget); // Using author from TestPodcast
      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);
      final descriptionFinder = find.widgetWithText(HtmlWidget, 'An episode about grand things.');
      expect(descriptionFinder, findsOneWidget);


      // Verify Semantics of Information
      expect(tester.getSemantics(find.text(testEpisode.title)),
          matchesSemantics(label: testEpisode.title, isHeader: true)); // Titles are often headers
      expect(tester.getSemantics(find.text(testPodcast.author!)),
          matchesSemantics(label: testPodcast.author!));
      expect(tester.getSemantics(imageFinder), matchesSemantics(label: 'Episode artwork'));
      expect(tester.getSemantics(descriptionFinder), matchesSemantics(value: contains('An episode about grand things.')));


      // Verify Controls Presence (detailed semantics in their own tests)
      final playPauseButtonFinder = find.byType(PlayPauseButton);
      expect(playPauseButtonFinder, findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget); // Paused state

      final rewindButtonFinder = find.widgetWithIcon(MediaActionButton, Icons.replay_10_rounded);
      expect(rewindButtonFinder, findsOneWidget);
      expect(tester.getSemantics(rewindButtonFinder), matchesSemantics(tooltip: 'Rewind 10 seconds'));

      final ffButtonFinder = find.widgetWithIcon(MediaActionButton, Icons.forward_30_rounded);
      expect(ffButtonFinder, findsOneWidget);
      expect(tester.getSemantics(ffButtonFinder), matchesSemantics(tooltip: 'Fast-forward 30 seconds'));

      expect(find.byType(EpisodeProgressBar), findsOneWidget);
      // Check progress bar semantics (value from PlaybackState)
      expect(tester.getSemantics(find.byType(EpisodeProgressBar)), matchesSemantics(value: contains("16 percent"))); // 5min / 30min = 16.6%

      // Initial focus (often on a primary action or the modal itself for screen readers)
      // This is hard to precisely test without knowing the exact focus traversal group setup.
      // testA11yGuidelines will help catch major focus issues.

      await tester.testA11yGuidelines(label: 'PlayerModal - Episode Paused');

      // Test Interaction
      await tester.tap(playPauseButtonFinder);
      verify(() => mockAudioPlayerPod.play()).called(1);

      await tester.tap(rewindButtonFinder);
      verify(() => mockAudioPlayerPod.rewind(const Duration(seconds: 10))).called(1);

      await tester.tap(ffButtonFinder);
      verify(() => mockAudioPlayerPod.fastForward(const Duration(seconds: 30))).called(1);
    });

    testWidgets('Modal when no episode is playing: handles gracefully and meets a11y', (tester) async {
      const noData = AsyncData<(Episode, Podcast)?>(null);
      final idleState = createPlaybackState(playing: false, processingState: AudioProcessingState.idle);

      await pumpEpisodePlayerModal(tester,
          episodeWithPodcastAsyncValue: noData,
          playbackState: idleState);

      // Verify placeholder UI or minimal content
      // The modal might show "Nothing Playing" or be mostly empty.
      // Depending on implementation, it might not even open or show a specific message.
      // For this test, let's assume it shows a simple message if it opens.
      // If EpisodePlayerModal internally decides not to show content based on null data,
      // then these finds would fail, which is correct.
      // expect(find.text("Nothing Playing"), findsOneWidget); // Or similar placeholder

      // If it shows, check its accessibility
      await tester.testA11yGuidelines(label: 'PlayerModal - No Episode');
    });

    testWidgets('Modal in loading state: shows indicator and meets a11y', (tester) async {
      const loadingData = AsyncLoading<(Episode, Podcast)?>();
      final idleState = createPlaybackState(processingState: AudioProcessingState.idle);

      await pumpEpisodePlayerModal(tester,
          episodeWithPodcastAsyncValue: loadingData,
          playbackState: idleState);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Basic check for indicator semantics
      expect(tester.getSemantics(find.byType(CircularProgressIndicator)), matchesSemantics(isFocusable: false));

      await tester.testA11yGuidelines(label: 'PlayerModal - Loading State');
    });
  });
}
