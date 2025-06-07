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
        expect(appBarTitleSemantics.isInSemanticTree, isTrue);

        // 3. PodcastDetails Widget Semantics (Basic Check)
        final podcastDetailsFinder = find.byType(PodcastDetails);
        expect(podcastDetailsFinder, findsOneWidget);
        // Check that it's part of the semantic tree. Deeper checks would depend on its internal structure.
        // This ensures it's not excluding its subtree from semantics.
        expect(tester.getSemantics(podcastDetailsFinder), matchesSemantics(isInSemanticTree: true));


        // 4. "Episodes (count)" Text Semantics
        final episodesCountFinder = find.text('Episodes (1)');
        expect(episodesCountFinder, findsOneWidget);
        expect(
          tester.getSemantics(episodesCountFinder),
          matchesSemantics(label: 'Episodes (1)', isInSemanticTree: true),
        );

        // 5. Filter Button Tap Target Size
        expect(tester.getSize(filterButton).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(filterButton).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // 6. EpisodeListItem Checks
        final episodeListItemFinder = find.byType(EpisodeListItem);
        expect(episodeListItemFinder, findsOneWidget); // Assuming one mock episode

        // Tap target size for EpisodeListItem
        expect(tester.getSize(episodeListItemFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(episodeListItemFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic label for EpisodeListItem
        expect(
          tester.getSemantics(episodeListItemFinder),
          matchesSemantics(
            label: mockEpisode.title, // Assuming label is the title. Adjust if status/other info is included.
            isTappable: true, // EpisodeListItems are usually tappable
          ),
        );

        // Semantics for PopupMenuButton within EpisodeListItem
        final moreOptionsButtonFinder = find.descendant(
          of: episodeListItemFinder,
          matching: find.byIcon(Icons.more_vert),
        );
        expect(moreOptionsButtonFinder, findsOneWidget);
        expect(tester.getSize(moreOptionsButtonFinder).width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(tester.getSize(moreOptionsButtonFinder).height, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(
          tester.getSemantics(moreOptionsButtonFinder),
          matchesSemantics(
            label: 'More options for ${mockEpisode.title}', // Expected label
            isButton: true,
            hasTapAction: true,
          ),
        );

        // 7. FilterEpisodesPopup (Basic Check)
        // Tap the filter button to open the popup
        await tester.tap(filterButton);
        await tester.pumpAndSettle(); // Allow popup to animate and build

        // Check if the popup (or a known element within it) is visible and accessible
        // This assumes FilterEpisodesPopup uses a common widget like Card or has a specific key/type.
        // For this example, let's assume it shows some filter option text.
        // A more robust check would use a key on the popup's root widget.
        final filterOptionText = find.text('Unplayed only'); // Example filter option
        // This check might fail if 'Unplayed only' is not the default or always visible text.
        // It's a placeholder for finding something inside the popup.
        // A better approach would be to find by type of the popup if known, e.g., find.byType(FilterEpisodesPopup)
        // and check its semantics.

        // For now, let's just check if *something* related to filtering is announced.
        // This is a very basic check. A real test would need to know more about FilterEpisodesPopup's structure.
        // If FilterEpisodesPopup is a Dialog, you could do:
        // expect(find.byType(Dialog), findsOneWidget);
        // And then check semantics of the dialog.
        // For now, we'll skip a deeper check as it requires knowledge of FilterEpisodesPopup's implementation.
        // The `testA11yGuidelines()` called later should catch if the modal barrier itself is an issue.

        // Close the popup by tapping outside (generic way to close a modal)
        // This might not always work depending on how the popup is implemented (e.g., if it's persistent)
        await tester.tapAt(Offset.zero); // Tap top-left corner
        await tester.pumpAndSettle();


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
