import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart'; // For PodcastMediaItem
import '../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension etc.

// --- Mocks ---
class MockEpisode extends Mock implements Episode {
  // Provide default non-null values for getters if not specified by 'when'
  @override
  EpisodeId get id => EpisodeId('mock_episode_id');
  @override
  PodcastId get podcastId => PodcastId('mock_podcast_id');
  @override
  String get title => 'Mock Episode Title';
  @override
  Uri get url => Uri.parse('http://example.com/mock.mp3');
  @override
  Uri get imageUrl => Uri.parse('http://example.com/mock_image.png');
  @override
  String get localFilePath => 'mock_file_path';
  @override
  PodcastMediaItem mediaItem({
    Duration? actualDuration,
    bool? isPlayingFromDownloaded,
  }) {
    return PodcastMediaItem(
      id: id.id,
      album: podcastId.id,
      title: title,
      artist: podcastId.id, // Assuming podcastId can serve as artist
      duration: actualDuration ?? const Duration(minutes: 10),
      artUri: imageUrl,
      extras: {
        'url': url.toString(),
        'downloaded': isPlayingFromDownloaded ?? false,
        'episodeId': id.id,
        'podcastId': podcastId.id,
      },
    );
  }
}

class MockAudioPlayerPod extends Mock implements AudioPlayerPod {}

// Helper to create PlaybackState
PlaybackState createPlaybackState({
  bool playing = false,
  AudioProcessingState processingState = AudioProcessingState.ready,
  Duration position = Duration.zero,
}) {
  return PlaybackState(
    controls: [MediaControl.play, MediaControl.pause], // Common controls
    processingState: processingState,
    playing: playing,
    updatePosition: position,
    bufferedPosition: Duration.zero,
    speed: 1.0,
    queueIndex: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockEpisode mockEpisode;
  late MockAudioPlayerPod mockAudioPlayerNotifier;

  setUp(() {
    mockEpisode = MockEpisode();
    mockAudioPlayerNotifier = MockAudioPlayerPod();

    // Default stubs
    when(() => mockAudioPlayerNotifier.playEpisode(any())).thenAnswer((_) async {});
    when(() => mockAudioPlayerNotifier.play()).thenAnswer((_) async {});
    when(() => mockAudioPlayerNotifier.pause()).thenAnswer((_) async {});
  });

  Future<void> pumpPlayEpisodeButton(
    WidgetTester tester, {
    required PlaybackState playbackState,
    EpisodeId? currentPlayingEpisodeId, // Null if nothing is playing or current is different
  }) async {
    // This is a common way to update a provider's state in tests if it's a simple Notifier.
    // If AudioPlayerPod is more complex (e.g., AsyncNotifier), this might need adjustment.
    // For this test, we are primarily concerned with the state it exposes.
    when(() => mockAudioPlayerNotifier.currentlyPlayingEpisodeId)
        .thenReturn(currentPlayingEpisodeId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioStateProvider.overrideWithValue(AsyncData(playbackState)),
          audioPlayerPodProvider.overrideWith((ref) => mockAudioPlayerNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PlayEpisodeButton(mockEpisode),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('PlayEpisodeButton Accessibility Tests', () {
    testWidgets(
        'Paused state (different/no episode playing): shows play, correct semantics, a11y',
        (tester) async {
      await pumpPlayEpisodeButton(
        tester,
        playbackState: createPlaybackState(playing: false),
        currentPlayingEpisodeId: EpisodeId('other_episode'), // Not this episode
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Play episode',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'PlayButton - Paused (Other Episode)');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerNotifier.playEpisode(mockEpisode)).called(1);
    });

    testWidgets(
        'Playing state (this episode is playing): shows pause, correct semantics, a11y',
        (tester) async {
      when(() => mockEpisode.id).thenReturn(EpisodeId('this_episode_playing'));
      await pumpPlayEpisodeButton(
        tester,
        playbackState: createPlaybackState(playing: true),
        currentPlayingEpisodeId: EpisodeId('this_episode_playing'),
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Pause episode',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'PlayButton - Playing (This Episode)');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerNotifier.pause()).called(1);
    });

    testWidgets(
        'Paused state (this episode is current but paused): shows play, correct semantics, a11y',
        (tester) async {
      when(() => mockEpisode.id).thenReturn(EpisodeId('this_episode_paused'));
      await pumpPlayEpisodeButton(
        tester,
        playbackState: createPlaybackState(playing: false),
        currentPlayingEpisodeId: EpisodeId('this_episode_paused'),
      );

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget); // Should show play to resume

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Play episode', // Tooltip might still be "Play episode"
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'PlayButton - Paused (This Episode)');

      await tester.tap(buttonFinder);
      verify(() => mockAudioPlayerNotifier.play()).called(1); // Calls general play to resume
    });


    testWidgets('Loading state: shows indicator, disabled, correct semantics, a11y', (tester) async {
      await pumpPlayEpisodeButton(
        tester,
        playbackState: createPlaybackState(processingState: AudioProcessingState.loading),
        currentPlayingEpisodeId: mockEpisode.id, // Loading this episode
      );

      final buttonFinder = find.byType(PlayEpisodeButton); // Find by actual widget type
      expect(buttonFinder, findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Ensure IconButton is there but content is the indicator
      final iconButton = tester.widget<IconButton>(find.descendant(of: buttonFinder, matching: find.byType(IconButton)));
      expect(iconButton.onPressed, isNull); // Disabled

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      // IconButton itself might be excluded or its semantics adapted when showing progress
      // Check semantics of the PlayEpisodeButton wrapper
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          // isEnabled: false, // The IconButton child is disabled. PlayEpisodeButton might not have this directly.
          // isButton: true, // Role might be different if it's just a container for progress
          label: contains("Loading"), // Or similar, depending on implementation
        )
      );

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(tester.getSemantics(progressIndicatorFinder), matchesSemantics(label: isEmpty, isFocusable: false));

      await tester.testA11yGuidelines(label: 'PlayButton - Loading State');
    });

    testWidgets('Buffering state: shows indicator, disabled, correct semantics, a11y', (tester) async {
      await pumpPlayEpisodeButton(
        tester,
        playbackState: createPlaybackState(processingState: AudioProcessingState.buffering),
        currentPlayingEpisodeId: mockEpisode.id, // Buffering this episode
      );

      final buttonFinder = find.byType(PlayEpisodeButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final iconButton = tester.widget<IconButton>(find.descendant(of: buttonFinder, matching: find.byType(IconButton)));
      expect(iconButton.onPressed, isNull);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(label: contains("Loading")) // Assuming buffering also uses "Loading" or similar
      );

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(tester.getSemantics(progressIndicatorFinder), matchesSemantics(label: isEmpty, isFocusable: false));

      await tester.testA11yGuidelines(label: 'PlayButton - Buffering State');
    });

    testWidgets('Error state (from audioStateProvider): disabled, shows play, a11y', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            audioStateProvider.overrideWithValue(AsyncError("Player error", StackTrace.current)),
            audioPlayerPodProvider.overrideWith((ref) => mockAudioPlayerNotifier),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: PlayEpisodeButton(mockEpisode),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      // In error state, it might show a play icon but be disabled, or an error icon.
      // Assuming it defaults to a disabled play icon if PlayEpisodeButton doesn't handle error icon specifically.
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      final iconButtonWidget = tester.widget<IconButton>(buttonFinder);
      expect(iconButtonWidget.onPressed, isNull); // Should be disabled

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Play episode', // Tooltip might still be present
          isButton: true,
          isEnabled: false, // Crucially, it's disabled
        ),
      );
      await tester.testA11yGuidelines(label: 'PlayButton - Provider Error State');
    });

  });
}
