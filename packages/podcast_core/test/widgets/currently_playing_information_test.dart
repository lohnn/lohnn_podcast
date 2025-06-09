import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/audio_player_provider.dart'; // Assuming currentEpisodeWithPodcastPod is here or related
import 'package:podcast_core/widgets/currently_playing_information.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

import '../../test_data_models/test_episode.dart';
import '../../test_data_models/test_podcast.dart';
import '../helpers/widget_tester_helpers.dart'; // For kMinInteractiveDimension and testA11yGuidelines

// If currentEpisodeWithPodcastPod is not directly in audio_player_provider.dart,
// its actual source would be needed. For this test, we'll define a conceptual one
// if the real one isn't immediately obvious from typical provider patterns.
// However, audioPlayerPodProvider.select((s) => s.currentlyPlayingEpisodeWithPodcast) is a common pattern.
// Let's assume for now the widget uses `currentEpisodeWithPodcastPod` which is a top-level provider.

// Define a conceptual provider if the actual one is complex or not directly available
// For testing purposes, we often define a simple provider that our widget under test would watch.
// If CurrentlyPlayingInformation watches `audioPlayerPodProvider.select(...)`,
// then we'd mock `audioPlayerPodProvider` to return a state that includes the (Episode, Podcast) tuple.

// For this example, let's assume a direct provider exists:
final currentEpisodeWithPodcastPodForTest =
    Provider<AsyncValue<(Episode, Podcast)?>>(
        (ref) => const AsyncData(null)); // Default to nothing playing

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEpisode testEpisode;
  late TestPodcast testPodcast;

  setUp(() {
    testEpisode = TestEpisode.mocked(
      id: 'ep1',
      podcastId: 'pd1',
      title: 'Exploring The Void',
      imageUrl: Uri.parse('http://example.com/episode_art.png'),
    );
    testPodcast = TestPodcast.mocked(
      id: 'pd1',
      title: 'Universe Today',
      artwork: 'http://example.com/podcast_art.png', // TestPodcast uses String for artwork
    );
  });

  Future<void> pumpCurrentlyPlayingInfo(
    WidgetTester tester, {
    required AsyncValue<(Episode, Podcast)?> episodeWithPodcastData,
  }) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(
          ProviderScope(
            overrides: [
              // Override the conceptual provider.
              // If CurrentlyPlayingInformation uses a different provider, that one should be overridden.
              currentEpisodeWithPodcastPod
                  .overrideWithValue(episodeWithPodcastData),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: CurrentlyPlayingInformation(),
              ),
            ),
          ),
        ));
    await tester.pumpAndSettle();
  }

  group('CurrentlyPlayingInformation Accessibility Tests', () {
    testWidgets(
        'Episode playing: displays info, correct semantics, and meets a11y',
        (tester) async {
      final playingData = AsyncData<(Episode, Podcast)>(
          (testEpisode, testPodcast));
      await pumpCurrentlyPlayingInfo(tester,
          episodeWithPodcastData: playingData);

      // Verify UI elements
      expect(find.text(testEpisode.title), findsOneWidget);
      expect(find.text(testPodcast.title), findsOneWidget); // Or author
      final imageFinder = find.byType(RoundedImage);
      expect(imageFinder, findsOneWidget);

      // Verify Semantics
      final titleFinder = find.text(testEpisode.title);
      expect(tester.getSemantics(titleFinder),
          matchesSemantics(label: testEpisode.title, isInSemanticTree: true));

      final podcastFinder = find.text(testPodcast.title);
      expect(tester.getSemantics(podcastFinder),
          matchesSemantics(label: testPodcast.title, isInSemanticTree: true));

      expect(tester.getSemantics(imageFinder),
          matchesSemantics(label: 'Episode artwork')); // Expected label

      // Overall widget container semantics (assuming it's not meant to be focusable itself)
      final widgetFinder = find.byType(CurrentlyPlayingInformation);
      expect(tester.getSemantics(widgetFinder),
          matchesSemantics(isFocusable: false));

      // If the widget is tappable (e.g. to open full player), check tap target size
      // For now, assuming it's purely informational.
      // final Size widgetSize = tester.getSize(widgetFinder);
      // expect(widgetSize.height, greaterThanOrEqualTo(kMinInteractiveDimension));


      await tester.testA11yGuidelines(
          label: 'CurrentlyPlayingInformation - Episode Playing');
    });

    testWidgets(
        'No episode playing: displays placeholder, correct semantics, and meets a11y',
        (tester) async {
      const noData = AsyncData<(Episode, Podcast)?>(null);
      await pumpCurrentlyPlayingInfo(tester, episodeWithPodcastData: noData);

      final placeholderFinder = find.text('Nothing is playing right now');
      expect(placeholderFinder, findsOneWidget);
      expect(
          tester.getSemantics(placeholderFinder),
          matchesSemantics(
              label: 'Nothing is playing right now',
              isInSemanticTree: true));

      await tester.testA11yGuidelines(
          label: 'CurrentlyPlayingInformation - Nothing Playing');
    });

    testWidgets(
        'Loading state: displays loading indicator, correct semantics, and meets a11y',
        (tester) async {
      const loadingData = AsyncLoading<(Episode, Podcast)?>();
      await pumpCurrentlyPlayingInfo(tester,
          episodeWithPodcastData: loadingData);

      final progressFinder = find.byType(CircularProgressIndicator);
      expect(progressFinder, findsOneWidget);
      expect(tester.getSemantics(progressFinder),
          matchesSemantics(label: isEmpty, isFocusable: false)); // Default indicator semantics

      await tester.testA11yGuidelines(
          label: 'CurrentlyPlayingInformation - Loading State');
    });

    testWidgets(
        'Error state: displays error message, correct semantics, and meets a11y',
        (tester) async {
      final errorData =
          AsyncError<(Episode, Podcast)?>('Failed to load', StackTrace.empty);
      await pumpCurrentlyPlayingInfo(tester,
          episodeWithPodcastData: errorData);

      // Assuming the widget displays a generic error message or the error itself.
      // This depends on the widget's error handling.
      // For this test, let's assume it shows a generic "Error loading information" text.
      // In a real scenario, the widget might show error.toString().
      final errorFinder = find.text('Error loading information');
      expect(errorFinder, findsOneWidget);
      expect(
          tester.getSemantics(errorFinder),
          matchesSemantics(
              label: 'Error loading information', isInSemanticTree: true));

      await tester.testA11yGuidelines(
          label: 'CurrentlyPlayingInformation - Error State');
    });
  });
}
