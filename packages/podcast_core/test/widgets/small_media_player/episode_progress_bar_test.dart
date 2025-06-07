import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/small_media_player/episode_progress_bar.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart'; // For PodcastMediaItem
import '../../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension etc.

// --- Mocks ---
class MockEpisode implements Episode {
  @override
  final EpisodeId id;
  @override
  final PodcastId podcastId;
  @override
  final String title;
  @override
  final Uri url;
  @override
  final Uri imageUrl;
  @override
  final String? description; // Made nullable
  @override
  final DateTime? pubDate; // Made nullable
  @override
  final Duration? duration; // Crucial for progress calculation

  MockEpisode({
    required String id,
    required String podcastId,
    this.title = 'Mock Episode Title',
    String url = 'http://example.com/mock.mp3',
    String imageUrl = 'http://example.com/mock_image.png',
    this.description,
    this.pubDate,
    this.duration,
  })  : id = EpisodeId(id),
        podcastId = PodcastId(podcastId),
        url = Uri.parse(url),
        imageUrl = Uri.parse(imageUrl);

  @override
  String get localFilePath => '${id.id}-${url.pathSegments.last}';

  @override
  PodcastMediaItem mediaItem(
      {Duration? actualDuration, bool? isPlayingFromDownloaded}) {
    return PodcastMediaItem(
      id: id.id,
      album: podcastId.id,
      title: title,
      artist: podcastId.id,
      duration: actualDuration ?? duration ?? const Duration(minutes: 10),
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

// Helper to create PlaybackState
PlaybackState createPlaybackStateWithPosition(
  Duration position, {
  AudioProcessingState processingState = AudioProcessingState.ready,
  bool playing = true,
  String? mediaId, // To simulate which episode is playing
}) {
  return PlaybackState(
    controls: [MediaControl.play, MediaControl.pause],
    processingState: processingState,
    playing: playing,
    updatePosition: position,
    bufferedPosition: Duration.zero,
    speed: 1.0,
    queueIndex: 0,
    currentMediaItemDuration: null, // This might be set by audio_service from mediaItem.duration
    mediaItem: mediaId != null ? MediaItem(id: mediaId, title: 'mock media item') : null,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpEpisodeProgressBar(
    WidgetTester tester, {
    required Episode episode,
    required PlaybackState playbackState,
    EpisodeId? currentlyPlayingEpisodeIdOverride, // For fine-grained control
    double height = 4.0,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioStateProvider.overrideWithValue(AsyncData(playbackState)),
          // Control which episode is "currently playing" according to the main player state
          currentlyPlayingEpisodeIdProvider.overrideWithValue(
            currentlyPlayingEpisodeIdOverride ?? (playbackState.mediaItem?.id != null ? EpisodeId(playbackState.mediaItem!.id) : null),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: EpisodeProgressBar(episode, height: height),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(); // Allow progress bar to update
  }

  group('EpisodeProgressBar Accessibility Tests', () {
    testWidgets('0% progress: correct visuals, semantics, and a11y',
        (tester) async {
      final mockEpisode = MockEpisode(id: 'ep1', podcastId: 'pd1', duration: const Duration(minutes: 10));
      final playbackState = createPlaybackStateWithPosition(Duration.zero, mediaId: 'ep1');
      await pumpEpisodeProgressBar(tester, episode: mockEpisode, playbackState: playbackState);

      final progressBarFinder = find.byType(LinearProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(progressBarFinder);
      expect(progressIndicator.value, moreOrLessEquals(0.0));

      // Semantics: Check for a descriptive label.
      // The exact label format depends on EpisodeProgressBar's implementation.
      // It might combine current time and total duration, or show percentage.
      expect(
        tester.getSemantics(progressBarFinder),
        matchesSemantics(
          value: '0 percent', // Standard format for progress value
          label: 'Progress: 0 seconds of 10 minutes', // Example descriptive label
          isFocusable: false, // Progress bars are typically not focusable
        ),
      );
      await tester.testA11yGuidelines(label: 'ProgressBar - 0%');
    });

    testWidgets('50% progress: correct visuals, semantics, and a11y',
        (tester) async {
      final mockEpisode = MockEpisode(id: 'ep1', podcastId: 'pd1', duration: const Duration(minutes: 10));
      final playbackState = createPlaybackStateWithPosition(const Duration(minutes: 5), mediaId: 'ep1');
      await pumpEpisodeProgressBar(tester, episode: mockEpisode, playbackState: playbackState);

      final progressBarFinder = find.byType(LinearProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(progressBarFinder);
      expect(progressIndicator.value, moreOrLessEquals(0.5));

      expect(
        tester.getSemantics(progressBarFinder),
        matchesSemantics(
          value: '50 percent',
          label: 'Progress: 5 minutes of 10 minutes',
          isFocusable: false,
        ),
      );
      await tester.testA11yGuidelines(label: 'ProgressBar - 50%');
    });

    testWidgets('100% progress: correct visuals, semantics, and a11y',
        (tester) async {
      final mockEpisode = MockEpisode(id: 'ep1', podcastId: 'pd1', duration: const Duration(minutes: 10));
      final playbackState = createPlaybackStateWithPosition(const Duration(minutes: 10), mediaId: 'ep1');
      await pumpEpisodeProgressBar(tester, episode: mockEpisode, playbackState: playbackState);

      final progressBarFinder = find.byType(LinearProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(progressBarFinder);
      expect(progressIndicator.value, moreOrLessEquals(1.0));

      expect(
        tester.getSemantics(progressBarFinder),
        matchesSemantics(
          value: '100 percent',
          label: 'Progress: 10 minutes of 10 minutes',
          isFocusable: false,
        ),
      );
      await tester.testA11yGuidelines(label: 'ProgressBar - 100%');
    });

    testWidgets('No duration (live stream): handles gracefully, semantics, a11y',
        (tester) async {
      final mockEpisode = MockEpisode(id: 'ep1', podcastId: 'pd1', duration: null); // No duration
      // For a live stream, position might still update, but total duration is unknown.
      final playbackState = createPlaybackStateWithPosition(const Duration(minutes: 5), mediaId: 'ep1');
      await pumpEpisodeProgressBar(tester, episode: mockEpisode, playbackState: playbackState);

      final progressBarFinder = find.byType(LinearProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(progressBarFinder);
      // Indeterminate progress bar (value is null) or could be 0 if duration is unknown.
      // Let's assume it shows an indeterminate bar.
      expect(progressIndicator.value, isNull, reason: "Progress bar should be indeterminate for null duration");

      // Semantics for indeterminate or live stream
      expect(
        tester.getSemantics(progressBarFinder),
        matchesSemantics(
          // Value might be absent or "unknown" for indeterminate progress.
          // Label should indicate it's live or progress is not applicable.
          label: 'Live stream', // Example label for live content
          isFocusable: false,
        ),
      );
      await tester.testA11yGuidelines(label: 'ProgressBar - No Duration (Live)');
    });

    testWidgets('Episode not currently playing: shows 0% progress, semantics, a11y', (tester) async {
      final mockEpisode = MockEpisode(id: 'ep1', podcastId: 'pd1', duration: const Duration(minutes: 10));
      // PlaybackState is for a *different* episode or nothing
      final playbackState = createPlaybackStateWithPosition(const Duration(minutes: 2), mediaId: 'ep2_another_episode');

      await pumpEpisodeProgressBar(
        tester,
        episode: mockEpisode, // We are testing the progress bar for 'ep1'
        playbackState: playbackState,
        // Explicitly ensure currentlyPlayingEpisodeIdProvider does not match mockEpisode.id
        currentlyPlayingEpisodeIdOverride: EpisodeId('ep2_another_episode')
      );

      final progressBarFinder = find.byType(LinearProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(progressBarFinder);
      // Should show 0% for an episode that isn't the one currently playing.
      expect(progressIndicator.value, moreOrLessEquals(0.0));

      expect(
        tester.getSemantics(progressBarFinder),
        matchesSemantics(
          value: '0 percent',
          label: 'Progress: 0 seconds of 10 minutes', // Or just "Progress: 0%" if duration isn't known in this context
          isFocusable: false,
        ),
      );
      await tester.testA11yGuidelines(label: 'ProgressBar - Episode Not Playing');
    });
  });
}
