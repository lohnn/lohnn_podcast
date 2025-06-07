import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart'; // For PodcastMediaItem if needed by MockEpisode
import '../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension etc.

// --- Mocks ---
class MockEpisode extends Mock implements Episode {
  @override
  EpisodeId get id => EpisodeId('mock_episode_id'); // Default
  @override
  PodcastId get podcastId => PodcastId('mock_podcast_id'); // Default
  @override
  String get title => 'Mock Episode Title'; // Default

  // Add stubs for other Episode getters if QueueButton uses them,
  // though it likely only needs 'id'.
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
    // Return a basic PodcastMediaItem if needed for some reason, though QueueButton shouldn't call this.
    return PodcastMediaItem(
      id: id.id,
      album: podcastId.id,
      title: title,
      artist: podcastId.id,
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

class MockPlaylistPod extends Mock implements PlaylistPod {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockEpisode mockEpisode;
  late MockPlaylistPod mockPlaylistNotifier;

  setUp(() {
    mockEpisode = MockEpisode();
    mockPlaylistNotifier = MockPlaylistPod();

    // Default stubs for actions (can be overridden in tests if specific return values are needed)
    when(() => mockPlaylistNotifier.addToQueue(any())).thenAnswer((_) async {});
    when(() => mockPlaylistNotifier.removeFromQueue(any())).thenAnswer((_) async {});
  });

  Future<void> pumpQueueButton(
    WidgetTester tester, {
    required bool isQueued, // To control the mock's isQueued behavior
  }) async {
    // Mock the isQueued method based on the test's needs
    when(() => mockPlaylistNotifier.isQueued(mockEpisode.id)).thenReturn(isQueued);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the Notifier itself, not the StateNotifierProvider's state directly
          playlistPodProvider.overrideWith((ref) => mockPlaylistNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: QueueButton(episode: mockEpisode),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('QueueButton Accessibility Tests', () {
    testWidgets(
        'Not in queue: shows add icon, correct semantics, adds to queue, and meets a11y',
        (tester) async {
      await pumpQueueButton(tester, isQueued: false);

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      // Assuming Icons.playlist_add or similar for "add to queue"
      // This icon might need adjustment based on actual implementation.
      expect(find.byIcon(Icons.playlist_add), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Add to queue',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'QueueButton - Not In Queue');

      await tester.tap(buttonFinder);
      verify(() => mockPlaylistNotifier.addToQueue(mockEpisode)).called(1);
    });

    testWidgets(
        'In queue: shows added/remove icon, correct semantics, removes from queue, and meets a11y',
        (tester) async {
      await pumpQueueButton(tester, isQueued: true);

      final buttonFinder = find.byType(IconButton);
      expect(buttonFinder, findsOneWidget);
      // Assuming Icons.playlist_add_check or Icons.check_circle for "in queue" state
      // This icon might need adjustment based on actual implementation.
      expect(find.byIcon(Icons.playlist_add_check), findsOneWidget);

      expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
      expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

      // The tooltip might be "Remove from queue" or "Added to queue".
      // Let's assume it's "Remove from queue" if tappable to remove.
      // Or, if it's purely informational "Added to queue", then hasTapAction might be false or different.
      // Assuming it's interactive to remove:
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          tooltip: 'Remove from queue',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      await tester.testA11yGuidelines(label: 'QueueButton - In Queue');

      await tester.tap(buttonFinder);
      verify(() => mockPlaylistNotifier.removeFromQueue(mockEpisode.id)).called(1);
    });

    // Test for a disabled state if the button can be disabled (e.g., while an action is pending)
    // For now, assuming it's always enabled if visible.
    // testWidgets('Disabled state: correct icon, semantics, and meets a11y', (tester) async {
    //   // Setup for disabled state (e.g., some condition makes it disabled)
    //   await pumpQueueButton(tester, isQueued: false, /* add a disabled flag if applicable */);
    //
    //   final buttonFinder = find.byType(IconButton);
    //   expect(buttonFinder, findsOneWidget);
    //   final iconButton = tester.widget<IconButton>(buttonFinder);
    //   expect(iconButton.onPressed, isNull); // Check if disabled
    //
    //   expect(tester.getSize(buttonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
    //   expect(tester.getSize(buttonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
    //
    //   expect(
    //     tester.getSemantics(buttonFinder),
    //     matchesSemantics(
    //       tooltip: 'Add to queue', // Tooltip might still be present
    //       isButton: true,
    //       isEnabled: false, // Key check
    //     ),
    //   );
    //   await tester.testA11yGuidelines(label: 'QueueButton - Disabled');
    // });
  });
}
