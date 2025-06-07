import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:podcast_core/helpers/equatable_map.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/providers/user_episode_status_provider.dart';
import 'package:podcast_core/screens/logged_in/playlist_screen.dart';
import 'package:podcast_core/widgets/episode_list_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/widget_tester_helpers.dart'; // Added import
import '../../test_data_models/test_episode.dart'; // Using existing mock

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockEpisode1 = TestEpisode.mocked(
    id: 'ep1',
    title: 'Playlist Episode 1 for A11y',
    podcastId: 'podcast1',
  );
  final mockEpisode2 = TestEpisode.mocked(
    id: 'ep2',
    title: 'Playlist Episode 2 for A11y',
    podcastId: 'podcast2',
  );

  final mockStatus1 = UserEpisodeStatus(
    episodeId: mockEpisode1.id,
    podcastId: mockEpisode1.podcastId,
    isPlayed: true,
    position: Duration.zero,
    completed: true,
    isFavorite: false,
    startedAt: null,
    completedAt: DateTime.now(),
    lastListenedAt: DateTime.now(),
  );

  // Helper to wrap a widget with ProviderScope and MaterialApp
  Widget createTestApp(Widget child, List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: child),
    );
  }

  group('PlaylistScreen Tests', () {
    testWidgets('renders correctly with data', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(const PlaylistScreen(), [
            playlistPodProvider.overrideWithBuild((_, _) async* {
              yield [mockEpisode1, mockEpisode2];
            }),
            userEpisodeStatusPodProvider.overrideWithBuild((_, _) async* {
              yield {mockEpisode1.id: mockStatus1}.equatable;
            }),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PlaylistScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Playlist'), findsOneWidget); // AppBar title
        expect(find.byType(ReorderableListView), findsOneWidget);
        expect(find.byType(EpisodeListItem), findsNWidgets(2));
        expect(find.text(mockEpisode1.title), findsOneWidget);
        expect(find.text(mockEpisode2.title), findsOneWidget);
      });
    });

    testWidgets('renders loading state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(const PlaylistScreen(), [
            playlistPodProvider.overrideWithBuild((_, _) async* {}),
            userEpisodeStatusPodProvider.overrideWithBuild((_, _) async* {
              yield <EpisodeId, UserEpisodeStatus>{}.equatable;
            }),
          ]),
        );

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    testWidgets('renders error state correctly', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(const PlaylistScreen(), [
            playlistPodProvider.overrideWithBuild((_, _) async* {
              throw 'Test error';
            }),
            userEpisodeStatusPodProvider.overrideWithBuild((_, _) async* {
              yield <EpisodeId, UserEpisodeStatus>{}.equatable;
            }),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.textContaining('Error: Test error'), findsOneWidget);
      });
    });

    testWidgets('renders correctly with empty playlist', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(const PlaylistScreen(), [
            playlistPodProvider.overrideWithBuild((_, _) async* {
              yield [];
            }),
            userEpisodeStatusPodProvider.overrideWithBuild((_, _) async* {
              yield <EpisodeId, UserEpisodeStatus>{}.equatable;
            }),
          ]),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PlaylistScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Playlist'), findsOneWidget);

        // Verify empty playlist message accessibility
        final emptyMessageFinder = find.text('Your playlist is empty.');
        expect(emptyMessageFinder, findsOneWidget);
        expect(
          tester.getSemantics(emptyMessageFinder),
          matchesSemantics(label: 'Your playlist is empty.', isInSemanticTree: true),
        );

        expect(find.byType(EpisodeListItem), findsNothing);
      });
    });

    testWidgets('passes accessibility guidelines and checks specific elements', (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          createTestApp(const PlaylistScreen(), [
            playlistPodProvider.overrideWithBuild((_, _) async* {
              yield [mockEpisode1, mockEpisode2];
            }),
            userEpisodeStatusPodProvider.overrideWithBuild((_, _) async* {
              yield {
                mockEpisode1.id: mockStatus1,
                // mockEpisode2 has no specific status, so it won't be "Played"
              }.equatable;
            }),
          ]),
        );
        await tester.pumpAndSettle();

        // 1. General A11y guidelines
        await tester.testA11yGuidelines();

        // 2. AppBar Title Semantics
        final appBarTitleFinder = find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Playlist'),
        );
        expect(appBarTitleFinder, findsOneWidget);
        expect(
          tester.getSemantics(appBarTitleFinder),
          matchesSemantics(label: 'Playlist', isHeader: true, isInSemanticTree: true),
        );

        // 3. EpisodeListItem Checks
        final episodeListItem1Finder = find.widgetWithText(EpisodeListItem, mockEpisode1.title);
        expect(episodeListItem1Finder, findsOneWidget);

        // Tap target size for EpisodeListItem 1
        final Size episodeListItem1Size = tester.getSize(episodeListItem1Finder);
        expect(episodeListItem1Size.width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(episodeListItem1Size.height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic label and actions for EpisodeListItem 1 (Played)
        // Note: The exact label might depend on how EpisodeListItem constructs its semantics.
        // This is an example assuming it combines title and status.
        // It also implicitly checks for tappable as matchesSemantics would look for tap actions by default if any.
        expect(
          tester.getSemantics(episodeListItem1Finder),
          matchesSemantics(
            label: '${mockEpisode1.title}, Played', // Adjusted expected label
            isTappable: true, // ReorderableListView items are inherently tappable for dragging
            // Other flags like isFocusable might also be relevant depending on implementation
          ),
        );

        final episodeListItem2Finder = find.widgetWithText(EpisodeListItem, mockEpisode2.title);
        expect(episodeListItem2Finder, findsOneWidget);

        // Tap target size for EpisodeListItem 2
        final Size episodeListItem2Size = tester.getSize(episodeListItem2Finder);
        expect(episodeListItem2Size.width, greaterThanOrEqualTo(kMinInteractiveDimension));
        expect(episodeListItem2Size.height, greaterThanOrEqualTo(kMinInteractiveDimension));

        // Semantic label and actions for EpisodeListItem 2 (Not played)
        expect(
          tester.getSemantics(episodeListItem2Finder),
          matchesSemantics(
            label: mockEpisode2.title, // No status suffix if not played/no status
            isTappable: true,
          ),
        );

        // 4. No other interactive elements specified to check for now.
      });
    });
  });
}
