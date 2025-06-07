import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/episodes_filter_state.dart';
import 'package:podcast_core/providers/episodes_filter_provider.dart';
import 'package:podcast_core/providers/episodes_provider.dart';
import 'package:podcast_core/screens/logged_in/podcast_details_screen.dart';
import 'package:podcast_core/widgets/episode_list_item.dart';
import 'package:podcast_core/widgets/podcast_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/widget_tester_helpers.dart'; // Added import
import '../../test_data_models/test_episode.dart';
import '../../test_data_models/test_podcast.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockPodcast = TestPodcast.mocked(
    title: 'Accessible Podcast Title', // Using a distinct title for clarity
  );
  final podcastId = mockPodcast.id;

  final mockEpisode = TestEpisode.mocked(
    podcastId: podcastId.id,
    title: 'Test Episode 1 for Details',
  );
  final mockEpisodeWithStatus = EpisodeWithStatus(
    episode: mockEpisode,
    isListened: false,
    isDownloaded: false,
    isFavorite: false,
    currentPosition: Duration.zero,
    lastListenedAt: null,
  );

  Widget createTestApp(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: child),
    );
  }

  group('PodcastDetailsScreen Tests', () {
    testWidgets('renders correctly with data and checks key semantics', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(PodcastDetailsScreen(podcastId), [
            episodesProvider(podcastId: podcastId).overrideWithValue(
              AsyncData((mockPodcast, [mockEpisodeWithStatus])),
            ),
            episodesFilterProvider.overrideWithValue(
              const EpisodesFilterState(),
            ),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PodcastDetailsScreen), findsOneWidget);
        expect(find.text(mockPodcast.title), findsOneWidget);
        expect(find.byType(PodcastDetails), findsOneWidget);
        expect(find.text('Episodes (1)'), findsOneWidget);
        expect(find.byType(EpisodeListItem), findsNWidgets(1));

        final filterButton = find.byIcon(Icons.filter_list);
        expect(filterButton, findsOneWidget);
        expect(
          tester.getSemantics(filterButton),
          matchesSemantics(
            hasTapAction: true,
            isButton: true,
            label: 'Filter episodes',
          ),
        );

        // AppBar title semantics check
        final appBarTitleFinder = find.text(mockPodcast.title);
        // Ensure it's part of the AppBar by finding it as a descendant
        expect(
          find.descendant(of: find.byType(AppBar), matching: appBarTitleFinder),
          findsOneWidget,
        );
        final SemanticsNode appBarTitleSemantics = tester.getSemantics(
          appBarTitleFinder,
        );
        // Titles in AppBar are often marked as headers by default
        expect(
          appBarTitleSemantics.hasFlag(SemanticsFlag.isHeader),
          isTrue,
          reason: "AppBar title should be a header",
        );
        // It should also have its label as its name
        expect(appBarTitleSemantics.label, mockPodcast.title);

        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });
    });

    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(PodcastDetailsScreen(podcastId), [
            episodesProvider(
              podcastId: podcastId,
            ).overrideWithValue(const AsyncLoading()),
            episodesFilterProvider.overrideWithValue(
              const EpisodesFilterState(),
            ),
          ]),
        );

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(PodcastDetailsScreen(podcastId), [
            episodesProvider(podcastId: podcastId).overrideWithValue(
              const AsyncError('Test error', StackTrace.empty),
            ),
            episodesFilterProvider.overrideWithValue(
              const EpisodesFilterState(),
            ),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.textContaining('Error: Test error'), findsOneWidget);
        // AppBar title might not render on error, or a generic title might.
        // If a generic title like "Error" is used, this check would be different.
        // For now, assuming the title specific to the podcast is not shown.
        expect(find.text(mockPodcast.title), findsNothing);
      });
    });

    testWidgets('renders correctly with empty episode list', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(PodcastDetailsScreen(podcastId), [
            episodesProvider(
              podcastId: podcastId,
            ).overrideWithValue(AsyncData((mockPodcast, []))),
            episodesFilterProvider.overrideWithValue(
              const EpisodesFilterState(),
            ),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PodcastDetailsScreen), findsOneWidget);
        expect(find.text(mockPodcast.title), findsOneWidget);
        expect(find.byType(PodcastDetails), findsOneWidget);
        expect(find.text('Episodes (0)'), findsOneWidget);
        expect(find.byType(EpisodeListItem), findsNothing);
      });
    });

    testWidgets('passes accessibility guidelines', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(PodcastDetailsScreen(podcastId), [
            episodesProvider(podcastId: podcastId).overrideWithValue(
              AsyncData((mockPodcast, [mockEpisodeWithStatus])),
            ),
            episodesFilterProvider.overrideWithValue(
              const EpisodesFilterState(),
            ),
          ]),
        );
        await tester.pumpAndSettle();
        await tester.testA11yGuidelines();
      });
    });
  });
}
